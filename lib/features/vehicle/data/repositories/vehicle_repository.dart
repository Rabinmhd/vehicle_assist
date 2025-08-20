import 'package:dio/dio.dart';
import 'package:parking_app_assignment/features/vehicle/domain/models/vehiclerequest_model.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../domain/models/vehicle.dart';

class VehicleRepository {
  final ApiClient _apiClient;

  VehicleRepository(this._apiClient);

  Future<VehicleListResponse> getVehicles({
    int limit = 10,
    int skip = 0,
    String? searchText,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.vehicleList,
        data: {
          'limit': limit,
          'skip': skip,
          if (searchText != null && searchText.isNotEmpty)
            'searchingText': searchText,
        },
      );
      return VehicleListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch vehicles';
    }
  }

  Future<VehicleSingleResponse> createVehicle(VehicleRequestModel vehicle) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.vehicleCreate,
        data: vehicle.toJson(),
      );
      return VehicleSingleResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to create vehicle';
    }
  }

  Future<VehicleSingleResponse> updateVehicle(VehicleRequestModel vehicle) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.vehicleEdit,
        data: vehicle.toJson(),
      );
      return VehicleSingleResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to update vehicle';
    }
  }

  Future<void> deleteVehicle(String id) async {
    try {
      await _apiClient.delete(
        ApiEndpoints.vehicleDelete,
        data: {'vehicleId': id},
      );
    } on DioException catch (e) {
      throw e.message ?? 'Failed to delete vehicle';
    }
  }
}
