import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  final String mobileNumber;
  final String otp;

  const LoginRequest({
    required this.mobileNumber,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
        'mobile': mobileNumber,
        'password': otp,
      };

  @override
  List<Object?> get props => [mobileNumber, otp];
}

class LoginResponse extends Equatable {
  final String accessToken;
  final User user;

  const LoginResponse({
    required this.accessToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [accessToken, user];
}

class User extends Equatable {
  final String id;
  final String name;
  final String uid;
  final int otp;
  final String mobileNumber;
  final int otpExpiry;
  final int createdAt;
  final int checkInStatus;
  final String createdUserId;
  final int updatedAt;
  final String updatedUserId;
  final int status;
  final int v;

  const User({
    required this.id,
    required this.name,
    required this.uid,
    required this.otp,
    required this.mobileNumber,
    required this.otpExpiry,
    required this.createdAt,
    required this.checkInStatus,
    required this.createdUserId,
    required this.updatedAt,
    required this.updatedUserId,
    required this.status,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['_name'] ?? '',
      uid: json['_uid'] ?? '',
      otp: json['_otp'] ?? 0,
      mobileNumber: json['_mobileNumber'] ?? '',
      otpExpiry: json['_otpExpiry'] ?? 0,
      createdAt: json['_createdAt'] ?? 0,
      checkInStatus: json['_checkInStatus'] ?? 0,
      createdUserId: json['_createdUserId'] ?? '',
      updatedAt: json['_updatedAt'] ?? 0,
      updatedUserId: json['_updatedUserId'] ?? '',
      status: json['_status'] ?? 0,
      v: json['__v'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        uid,
        otp,
        mobileNumber,
        otpExpiry,
        createdAt,
        checkInStatus,
        createdUserId,
        updatedAt,
        updatedUserId,
        status,
        v,
      ];
}
