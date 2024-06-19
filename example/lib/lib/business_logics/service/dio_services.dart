import 'package:flutter/foundation.dart';
import 'package:sample/screens/auth_screens/auth_screen.dart';
import 'package:sample/utils/common/navigator_extension.dart';
import 'package:dio/dio.dart';
import 'package:sample/business_logics/service/app_urls.dart';
import 'package:sample/business_logics/service/prefers_utility.dart';
import 'package:sample/models/dio_error_model.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/app_snackbar.dart';
import 'package:sample/utils/common/print_log.dart';

class HttpService {
  late Dio _dio;

  HttpService() {
    /// Initialize Dio with base options and set up interceptors
    _dio = Dio(BaseOptions(
      baseUrl: AppEndPoint.baseUrl,
      responseType: ResponseType.json,
      sendTimeout: const Duration(seconds: 155),
      connectTimeout: const Duration(seconds: 155),
      receiveTimeout: const Duration(seconds: 155),
    ));
    initializeInterceptors();
  }

  /// Set up interceptors for logging and authorization headers
  initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          /// Add authorization header if token is available
          final token =
          LocalStorage.instance.getString(PrefConstants.userToken);
          infoLog("Url => ${options.uri}");
          if (options.data.runtimeType == FormData) {
            /// Log request body for FormData requests
            final data = options.data as FormData;
            infoLog("Body => ");
            for (var element in data.fields) {
              infoLog("${element.key}:${element.value}");
            }
            for (var element in data.files) {
              infoLog("${element.key}:${element.value.filename}");
            }
          } else {
            /// Log request body for other types of requests
            infoLog("Body => ${options.data ?? {}}");
          }
          infoLog("Header => ${options.headers} ${token==null?"":"Authorization ...."}");
          if (token != null) {
            /// Add authorization header if token is available
            options.headers["Authorization"] = token;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          /// Log response data
          printLog("OnResponse => ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  /// Perform a GET request
  Future<Response> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Object? data,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.get(endPoint,queryParameters: queryParameters,data: data,onReceiveProgress: onReceiveProgress,);
    } on DioException catch (e) {
      /// Handle DioException and return response
      responseErrorHandler(response: e.response, dioErrorType: e.type);
      return e.response ??
          Response(requestOptions: RequestOptions(), data: e.response?.data);
    }
  }

  /// Perform a POST request
  Future<Response> post({
    required String endPoint,
    Object? data,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.post(endPoint, data: data,onReceiveProgress: onReceiveProgress,onSendProgress: onSendProgress,);
    } on DioException catch (e) {
      /// Handle DioException and return response
      responseErrorHandler(response: e.response, dioErrorType: e.type);
      return e.response ??
          Response(requestOptions: RequestOptions(), data: e.response?.data);
    }
  }
}

/// Handle errors in HTTP responses
void responseErrorHandler(
    {Response? response, DioExceptionType? dioErrorType}) {
  try {
    final model = ErrorModel.fromJson(response?.data ?? {});
    final message = model.error?.message ?? model.message ?? "";
    if (message.isNotEmpty && response?.statusCode != null) {
      /// Show snackbar with error message
      showSnackBar(message: message);
    } else {
      showSnackBar(
        /// Show generic error message
        message: dioErrorType == DioExceptionType.unknown ||
            dioErrorType == DioExceptionType.connectionTimeout ||
            dioErrorType == DioExceptionType.sendTimeout
            ? "No Network Found"
            : "Some Went Wrong",
      );
    }
  } catch (e,t) {
    /// Log and handle unexpected errors
    errorLog(e.toString()+t.toString(), fun: "DioService");
    // forceToLogin();
    showSnackBar(
      message: "Server Error",
    );
  }
  /// Log different types of errors
  if (response?.statusCode == 200) {
    errorLog("Successfully GET - 200 ${response?.data}");
  } else if (response?.statusCode == 201) {
    errorLog("Successfully POST - 201 ${response?.data}");
  } else if (response?.statusCode == 401) {
    /// Force user to login if authentication token is invalid
    forceToLogin();
    errorLog("Invalid AUTH Token - 401 ${response?.data}");
  } else if (response?.statusCode == 400) {
    /// Force user to login if authentication token is invalid
    forceToLogin();
    errorLog("Invalid AUTH Token - 400 ${response?.data}");
  } else if (response?.statusCode == 404) {
    errorLog("Not Found - 404 ${response?.data}");
  } else if (response?.statusCode == 422) {
    errorLog("Un-Processable Entity - 422 ${response?.data}");
  } else if (response?.statusCode == 500) {
    errorLog("Server Error - 500 ${response?.data}");
  } else if (response?.statusCode == 403) {
    errorLog("Forbidden - 403 ${response?.data}");
  } else if (dioErrorType == DioExceptionType.unknown ||
      dioErrorType == DioExceptionType.connectionTimeout ||
      dioErrorType == DioExceptionType.sendTimeout) {
    errorLog("No Network Found $dioErrorType ${response?.data ?? ""}");
  } else {
    errorLog("Some Went Wrong - ${response?.data ?? ""}");
  }
}
/// Force user to login again
Future<void> forceToLogin() async {
  if (kDebugMode) return;
  /// Check if global BuildContext exists
  if (globalBuildContextExits) {
    /// Remove user token from local storage
    await LocalStorage.instance.removeOnly(PrefConstants.userToken);

    /// Check if global BuildContext is mounted
    if (globalBuildContext.mounted) {
      /// Navigate to the LoginScreen and remove all routes on top of it
      globalBuildContext.pushAndRemoveUntil(ChooseUserScreen());
    }
  }
}
