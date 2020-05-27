class HttpException implements Exception {
  final message;

  const HttpException(this.message);
  @override
  String toString() {
    return message;
  }
}
