import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shopping_app/models/httpException.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime expiryDate;
  String _userID;
  Timer _authTimer;

  bool get isToken {
    return _token != null;
  }

  String get userId {
    return _userID;
  }

  String get idToken {
    if (expiryDate != null &&
        expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> authenticate(
      String email, String password, String action) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$action?key=AIzaSyA000TI3yTpvqFWKqg6jI24DFr7819EHpI';
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': userId,
        'expiryDate': expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  void logOut() {
    _userID = null;
    _token = null;
    expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  Future<bool> autoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData = json.decode(prefs.getString('userData'));
    final extractedDate = DateTime.parse(userData['expiryDate']);
    if (extractedDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData['token'];
    _userID = userData['userId'];
    expiryDate = userData['expiryDate'];
    _autoLogOut();
    notifyListeners();
    return true;
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeOfExpiry = expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeOfExpiry), logOut);
  }
}
