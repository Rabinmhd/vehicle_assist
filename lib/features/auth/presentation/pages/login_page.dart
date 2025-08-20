import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parking_app_assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:parking_app_assignment/features/auth/presentation/bloc/auth_state.dart';
import '../bloc/auth_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../vehicle/presentation/pages/vehicle_list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileController = TextEditingController(text: '9895680203');
  final _otpController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Store the token in secure storage
            getIt<SharedPreferences>().setString('accessToken', state.accessToken);
            // Navigate to vehicle list
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const VehicleListPage(),
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter mobile number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _otpController,
                    decoration: const InputDecoration(
                      labelText: 'OTP',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context.read<AuthBloc>().add(
                                      LoginSubmitted(
                                        mobileNumber: _mobileController.text,
                                        otp: _otpController.text,
                                      ),
                                    );
                              }
                            },
                      child: state is AuthLoading
                          ? const CircularProgressIndicator()
                          : const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
