import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/vehicle/data/repositories/vehicle_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Core
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPrefs);
  
  // API Client
  getIt.registerLazySingleton(() => ApiClient());
  
  // Repositories
  getIt.registerLazySingleton(() => AuthRepository(getIt()));
  getIt.registerLazySingleton(() => VehicleRepository(getIt()));
}
