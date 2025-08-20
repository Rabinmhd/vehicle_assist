import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/api/api_client.dart';
import 'core/di/injection.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/vehicle/data/repositories/vehicle_repository.dart';
import 'features/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(
                authRepository: AuthRepository(getIt<ApiClient>()),
              ),
            ),
            BlocProvider(
              create: (context) => VehicleBloc(
                vehicleRepository: VehicleRepository(getIt<ApiClient>()),
              ),
            ),
          ],
          child: MaterialApp(
            title: 'Parking Management',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            home: const LoginPage(),
          ),
        );
      },
    );
  }
}


