import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../domain/models/vehicle.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

// Bloc
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository vehicleRepository;

  VehicleBloc({required this.vehicleRepository}) : super(VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<CreateVehicle>(_onCreateVehicle);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<DeleteVehicle>(_onDeleteVehicle);
  }

  List<Vehicle> _currentVehicles = [];
  int _currentSkip = 0;
  static const int _limit = 10;

  Future<void> _onLoadVehicles(
    LoadVehicles event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      // Only show loading state for first page
      if (event.skip == 0) {
        emit(VehicleLoading());
        _currentVehicles = [];
        _currentSkip = 0;
      }

      final response = await vehicleRepository.getVehicles(
        limit: event.limit,
        skip: event.skip,
        searchText: event.searchText,
      );

      if (event.skip == 0) {
        _currentVehicles = response.vehicles;
      } else {
        _currentVehicles = [..._currentVehicles, ...response.vehicles];
      }

      _currentSkip = event.skip + response.vehicles.length;
      final hasMore = response.vehicles.length >= _limit;

      emit(VehicleSuccess(
        vehicles: _currentVehicles,
        message: response.message,
        hasMore: hasMore,
        currentSkip: _currentSkip,
      ));
    } catch (e) {
      emit(VehicleFailure(e.toString()));
    }
  }

  Future<void> _onCreateVehicle(
    CreateVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      emit(VehicleLoading());
      final response = await vehicleRepository.createVehicle(event.vehicleRequestModel);
      // Reset to first page after creating
      add(LoadVehicles(limit: _limit, skip: 0));
      // You can also emit success with the created vehicle if needed
      emit(VehicleActionSuccess(response.message));
    } catch (e) {
      emit(VehicleFailure(e.toString()));
    }
  }

  Future<void> _onUpdateVehicle(
    UpdateVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      emit(VehicleLoading());
      final response = await vehicleRepository.updateVehicle(event.vehicleRequestModel);
      // Reset to first page after updating
      add(LoadVehicles(limit: _limit, skip: 0));
      // You can also emit success with the updated vehicle if needed
      emit(VehicleActionSuccess(response.message));
    } catch (e) {
      emit(VehicleFailure(e.toString()));
    }
  }

  Future<void> _onDeleteVehicle(
    DeleteVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      // Keep the current state while deleting
      if (state is VehicleSuccess) {
        final currentState = state as VehicleSuccess;
        _currentVehicles = currentState.vehicles.where((v) => v.id != event.id).toList();
        emit(VehicleSuccess(
          vehicles: _currentVehicles,
          hasMore: currentState.hasMore,
          currentSkip: _currentSkip - 1,
          message: 'Vehicle deleted successfully',
        ));
      }
      
      await vehicleRepository.deleteVehicle(event.id);
      // Reload the list to ensure sync with server
      add(LoadVehicles(limit: _limit, skip: 0));
    } catch (e) {
      emit(VehicleFailure(e.toString()));
    }
  }
}
