class Vehicle {
  final String id;
  final String name;
  final String number;
  final String color;
  final String model;
  final int createdAt;
  final int updatedAt;
  final String? createdUserId;
  final String? updatedUserId;
  final int status;

  const Vehicle({
    required this.id,
    required this.name,
    required this.number,
    required this.color,
    required this.model,
    required this.createdAt,
    required this.updatedAt,
    this.createdUserId,
    this.updatedUserId,
    required this.status,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] ?? '',
      name: json['_name'] ?? '',
      number: json['_number'] ?? '',
      color: json['_color'] ?? '',
      model: json['_model'] ?? '',
      createdAt: json['_createdAt'] ?? -1,
      updatedAt: json['_updatedAt'] ?? -1,
      createdUserId: json['_createdUserId'],
      updatedUserId: json['_updatedUserId'],
      status: json['_status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_name': name,
      '_number': number,
      '_color': color,
      '_model': model,
    };
  }
}

class VehicleListResponse {
  final String message;
  final List<Vehicle> vehicles;

  const VehicleListResponse({
    required this.message,
    required this.vehicles,
  });

  factory VehicleListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final list = data['list'] as List;
    return VehicleListResponse(
      message: json['message'] ?? '',
      vehicles: list.map((e) => Vehicle.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

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
