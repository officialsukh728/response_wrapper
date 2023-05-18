part of 'response_wrapper.dart';

class AuthenticationException implements Exception {
  String? message;

  AuthenticationException(String? _message) {
    message = _message;
  }
}

class ConnectingTimedOut implements Exception {
  String? message;

  ConnectingTimedOut(String? _message) {
    message = _message;
  }
}
