import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';

final getIt = GetIt.instance;

void setupServices() {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://47.242.63.216:9527',
  ));

  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio: dio));
}
