import 'package:parking_app_assignment/features/vehicle/domain/models/vehicle.dart';

class VehicleSingleResponse {
  final String message;
  final Vehicle vehicle;

  const VehicleSingleResponse({
    required this.message,
    required this.vehicle,
  });

  factory VehicleSingleResponse.fromJson(Map<String, dynamic> json) {
    return VehicleSingleResponse(
      message: json['message'] ?? '',
      vehicle: Vehicle.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
