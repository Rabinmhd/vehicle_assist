import '../../domain/models/vehicle.dart';

abstract class VehicleState {}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleSuccess extends VehicleState {
  final List<Vehicle> vehicles;
  final String message;
  final bool hasMore;
  final int currentSkip;

  VehicleSuccess({
    required this.vehicles,
    required this.message,
    required this.hasMore,
    required this.currentSkip,
  });
}

class VehicleFailure extends VehicleState {
  final String error;
  VehicleFailure(this.error);
}

class VehicleActionSuccess extends VehicleState {
  final String message;
  VehicleActionSuccess(this.message);
}
