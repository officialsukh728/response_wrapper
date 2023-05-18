part of 'response_wrapper.dart';

class ResponseWrapper {
  int? status;
  String? message;
  dynamic response;

  ResponseWrapper({
    this.status,
    this.message,
    this.response,
  });

  ResponseWrapper.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    response = json["response"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    data["response"] = response;
    return data;
  }
}

abstract class RepoResponseStatus {
  static const int error = 500;
  static const int success = 200;
  static const int authentication = 401;
  static const int subscriptionExpire = 0;
  static const int platformException = 400;
  static const int notFoundException = 404;
  static const int serverIsTemporarilyUnable = 503;
}

dynamic responseChecker(Response<dynamic> response) {
  return (response.data.runtimeType == String)
      ? (jsonDecode(response.data))
      : (response.data);
}

ResponseWrapper getSuccessResponseWrapper(dynamic response) => ResponseWrapper(
      status: RepoResponseStatus.success,
      response: response,
    );

ResponseWrapper getFailedResponseWrapper(dynamic e, {dynamic response}) =>
    ResponseWrapper(
      status: RepoResponseStatus.error,
      message: e.toString(),
      response: response ?? false,
    );

String exceptionHandler({
  required Object e,
  required String functionName,
}) {
  if (e is AuthenticationException) {
    blocLog(
      msg: e.message ?? e.toString(),
      bloc: "AuthenticationException in =>$functionName",
    );
    return e.message ?? e.toString();
  } else if (e is PlatformException) {
    blocLog(
      msg: e.message ?? e.toString(),
      bloc: "PlatformException in ==>$functionName",
    );
    return e.message ?? e.toString();
  } else if (e is ConnectingTimedOut) {
    blocLog(
      msg: e.message ?? e.toString(),
      bloc: "ConnectingTimedOut in ==>$functionName",
    );
    return e.message ?? e.toString();
  } else if (e is SocketException) {
    blocLog(
      msg: e.message,
      bloc: "SocketException in ==>$functionName",
    );
    return e.message;
  } else {
    printLog("Unknown Exception ");
    blocLog(
      msg: e.toString(),
      bloc: functionName,
    );
    return e.toString();
  }
}

String getHandleFirebaseError({
  required String error,
  required String functionName,
}) {
  functionLog(msg: error, fun: "getHandleFirebaseError");
  if (error == "invalid-phone-number") {
    functionLog(
      msg: "Invalid phone number please enter valid phone number",
      fun: functionName,
    );
    return "Invalid phone number please enter valid phone number";
  } else if (error == "invalid-verification-code") {
    functionLog(
      msg: "invalid code",
      fun: functionName,
    );
    return "invalid code";
  } else if (error == "too-many-requests") {
    functionLog(
      msg: "Too Many Requests.Please try another number",
      fun: functionName,
    );
    return "Too Many Requests.Please try after 24 hours";
  } else if (error == "ERROR_EMAIL_ALREADY_IN_USE" ||
      error == "account-exists-with-different-credential" ||
      error == "email-already-in-use") {
    functionLog(
      msg: "Email already used. Go to login page.",
      fun: functionName,
    );
    return "Email already used. Go to login page.";
  } else if (error == "ERROR_WRONG_PASSWORD" || error == "wrong-password") {
    functionLog(
      msg: "Wrong email/password combination.",
      fun: functionName,
    );
    return "Wrong email/password combination.";
  } else if (error == "ERROR_USER_NOT_FOUND" || error == "user-not-found") {
    functionLog(
      msg: "No user found with this email.",
      fun: functionName,
    );
    return "No user found with this email.";
  } else if (error == "ERROR_USER_DISABLED" || error == "user-disabled") {
    functionLog(
      msg: "User disabled.",
      fun: functionName,
    );
    return "User disabled.";
  } else if (error == "ERROR_TOO_MANY_REQUESTS" ||
      error == "operation-not-allowed") {
    functionLog(
      msg: "Too many requests to log into this account.",
      fun: functionName,
    );
    return "Too many requests to log into this account.";
  } else if (error == "ERROR_OPERATION_NOT_ALLOWED" ||
      error == "operation-not-allowed") {
    functionLog(
      msg: "Server error, please try again later.",
      fun: functionName,
    );
    return "Server error, please try again later.";
  } else if (error == "ERROR_INVALID_EMAIL" || error == "invalid-email") {
    functionLog(
      msg: "Email address is invalid.",
      fun: functionName,
    );
    return "Email address is invalid.";
  } else {
    functionLog(
      msg: "Login failed. Please try again.",
      fun: functionName,
    );
    return "Login failed. Please try again.";
  }
}

void printLog(dynamic msg) {
  _printLog('\x1B[32m() => ${msg.toString()}\x1B[0m');
}

void functionLog({required dynamic msg, required dynamic fun}) {
  _printLog("\x1B[31m${fun.toString()} ::==> ${msg.toString()}\x1B[0m");
}

void _printLog(dynamic msg) {
  if (kDebugMode) {
    debugPrint(msg.toString());
  }
}

void blocLog({required String msg, required String bloc}) {
  _printLog("\x1B[31m${bloc.toString()} ::==> ${msg.toString()}\x1B[0m");
}
