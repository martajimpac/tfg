import 'package:equatable/equatable.dart';

class PerfilDataModel extends Equatable {
  final String? email;
  final String? role;
  final DateTime? lastSignInAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PerfilDataModel({
    this.email,
    this.role,
    this.lastSignInAt,
    this.createdAt,
    this.updatedAt,
  });

  factory PerfilDataModel.fromJson(Map<String, dynamic> json) {
    return PerfilDataModel(
      email: json['email'] as String?,
      role: json['role'] as String?,
      lastSignInAt: json['last_sign_in_at'] == null
          ? null
          : DateTime.parse(json['last_sign_in_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'role': role,
        'last_sign_in_at': lastSignInAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      email,
      role,
      lastSignInAt,
      createdAt,
      updatedAt,
    ];
  }
}
