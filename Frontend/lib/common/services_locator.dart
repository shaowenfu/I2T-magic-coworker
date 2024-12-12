import 'package:get_it/get_it.dart';
import '../services/api_service.dart';

final getIt = GetIt.instance;

void setupServices() {
  getIt.registerLazySingleton<ApiService>(() => ApiService());
}
