part of 'response_wrapper.dart';

enum DioServiceConst {
  get,
  post,
  delete,
  put,
  patch,
}

class DioService {
  late Dio _dio;

  DioService() {
    _dio = Dio();
  }

  Future<Response> request({
    required String url,
    DioServiceConst requestType = DioServiceConst.get,
    Map<String, dynamic>? body,
    Map<String, String>? customHeaders,
  }) async {
    Response response;
    try {
      Map<String, dynamic> map = body ?? {};
      Map<String, String> headers = customHeaders ?? getHeaders();
      String fullUrl = url;
      printLog("Hit Api Url 😛 ==> $fullUrl");
      printLog("Hit Api Body 😛 ==> $map");
      printLog("Api Headers ==> $headers");
      response = await _checkRequest(
        fullUrl: fullUrl,
        requestType: requestType,
        body: map,
        headers: headers,
      );
      printLog("Dio Response : $url ${response.data}");
    } on DioException catch (e) {
      blocLog(bloc: "Error message for", msg: "$url: ${e.message}");
      blocLog(bloc: "Error response for $url ", msg: "${e.response?.data}");
      blocLog(bloc: "Error Status Code ", msg: "${e.response?.statusCode}");
      throw throwException(e, url: url);
    }
    return response;
  }

  Future<Response> _checkRequest({
    required String fullUrl,
    required DioServiceConst requestType,
    required Map<String, dynamic> body,
    required Map<String, dynamic> headers,
  }) async {
    if (requestType == DioServiceConst.get) {
      printLog("Hit Request Type 😛 ==> get");
      return await _dio.get(
        fullUrl,
        options: Options(headers: headers),
        queryParameters: body,
      );
    } else if (requestType == DioServiceConst.post) {
      printLog("Hit Request Type 😛 ==> post");
      return await _dio.post(fullUrl,
          data: body, options: Options(headers: headers));
    }  else if (requestType == DioServiceConst.patch) {
      printLog("Hit Request Type 😛 ==> post");
      return await _dio.patch(fullUrl,
          data: body, options: Options(headers: headers));
    } else if (requestType == DioServiceConst.delete) {
      printLog("Hit Request Type 😛 ==> delete");
      return await _dio.delete(fullUrl,
          data: body, options: Options(headers: headers));
    } else {
      printLog("Hit Request Type 😛 ==> put");
      return await _dio.put(fullUrl,
          data: body, options: Options(headers: headers));
    }
  }

  Map<String, String> getHeaders() {
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    return headers;
  }

  dynamic throwException(DioException e, {String? url}) {
    if (e.response?.statusCode ==
        RepoResponseStatus.serverIsTemporarilyUnable) {
      throw AuthenticationException(
          "The server is temporarily unable to service.");
    } else if (e.type == DioExceptionType.connectionError) {
      throw ConnectingTimedOut("Connecting timed out please try again latter ");
    } else if (e.response != null &&
        (e.response?.statusCode == RepoResponseStatus.authentication)) {
      throw AuthenticationException("Authentication Failed");
    } else if (e.response != null &&
        (e.response?.statusCode == RepoResponseStatus.platformException ||
            e.response?.statusCode == RepoResponseStatus.notFoundException)) {
      throw PlatformException(
        details: e.response?.data.toString(),
        message: e.response?.data.toString(),
        code: "${e.response?.statusCode.toString()}",
        stacktrace: "stacktrace",
      );
    } else {
      throw Exception(e.message);
    }
  }
}
