import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class User2 extends Equatable {
  final String id;
  final String username;
  final String phone;
  final String email;
  final String avatarUrl;
  final String status;
  final String password;

  const User2({
    required this.id,
    required this.username,
    required this.phone,
    required this.email,
    required this.avatarUrl,
    required this.status,
    required this.password,
  });

  // get password => null;

  User2 copyWith(
      {String? id,
      String? username,
      String? phone,
      String? email,
      String? avatarUrl,
      String? status,
      String? password}) {
    return User2(
      id: id ?? this.id,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      password: password ?? this.password,
    );
  }

  factory User2.fromJson(Map<String, dynamic> json) {
    return User2(
      id: json['id'] ?? const Uuid().v4(),
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      avatarUrl:
          json['avatar_url'] ?? 'https://source.unsplash.com/random/?profile',
      status: json['status'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phone': phone,
      'email': email,
      'avatarUrl': avatarUrl,
      'status': status,
      'password': password,
    };
  }

  @override
  List<Object?> get props => [id, username, phone, email, avatarUrl, status];

  String? initials() {
    var letter =
        ((username.isNotEmpty == true ? username[0] : "")).toUpperCase();
    if (letter.contains(RegExp('^[a-zA-Z]+'))) {
      return letter;
    }
    return null;
  }
}
