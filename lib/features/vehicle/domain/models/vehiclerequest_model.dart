class VehicleRequestModel {
  final String name;
  final String model;
  final String color;
  final String vehicleNumber;

  VehicleRequestModel({
    required this.name,
    required this.model,
    required this.color,
    required this.vehicleNumber,
  });

  factory VehicleRequestModel.fromJson(Map<String, dynamic> json) {
    return VehicleRequestModel(
      name: json['name'] as String,
      model: json['model'] as String,
      color: json['color'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'model': model,
      'color': color,
      'vehicleNumber': vehicleNumber,
    };
  }
}