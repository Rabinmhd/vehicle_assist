import 'package:parking_app_assignment/features/vehicle/domain/models/vehiclerequest_model.dart';

abstract class VehicleEvent {}

class LoadVehicles extends VehicleEvent {
  final int limit;
  final int skip;
  final String? searchText;

  LoadVehicles({this.limit = 10, this.skip = 0, this.searchText});
}

class CreateVehicle extends VehicleEvent {
  final VehicleRequestModel vehicleRequestModel;
  CreateVehicle(this.vehicleRequestModel);
}

class UpdateVehicle extends VehicleEvent {
  final VehicleRequestModel vehicleRequestModel;
  UpdateVehicle(this.vehicleRequestModel);
}

class DeleteVehicle extends VehicleEvent {
  final String id;
  DeleteVehicle(this.id);
}
