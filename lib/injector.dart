part of 'response_wrapper.dart';

typedef AppRunner = FutureOr<void> Function();

class ResponseHttpInjector {
  static Future<void> init({
    required AppRunner appRunner,
  }) async {
    await GetIt.I.allReady();
    GetIt.I.registerSingleton<DioService>(DioService());
    appRunner();
  }
}

DioService get getDioService => GetIt.I.get<DioService>();