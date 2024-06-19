/// Wrapper class for handling response from API calls.
class ResponseWrapper {
  /// Response status code
  int? status;
  /// Response message
  String? message;
  /// Response data
  dynamic response;

  ResponseWrapper({
    this.status,
    this.message,
    this.response,
  });

  /// Constructs a [ResponseWrapper] instance from a JSON object.
  ResponseWrapper.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    response = json["response"];
  }

  /// Converts a [ResponseWrapper] instance to a JSON object.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    data["response"] = response;
    return data;
  }
}

/// Abstract class containing response status codes.
abstract class RepoResponseStatus {
  /// Success response status code
  static const int success = 200;

  /// Another success response status code
  static const int success1 = 201;

  /// Error response status code
  static const int error = 500;
}

/// Creates a success [ResponseWrapper] with the provided response data.
ResponseWrapper getSuccessResponseWrapper(dynamic response) => ResponseWrapper(
  status: RepoResponseStatus.success,
  message: "Success",
  response: response,
);

/// Creates a failed [ResponseWrapper] with the provided error and optional response data.
ResponseWrapper getFailedResponseWrapper(dynamic e, {dynamic response}) {
  return ResponseWrapper(
    status: RepoResponseStatus.error,
    message: e.toString(),
    response: response ?? false,
  );
}
