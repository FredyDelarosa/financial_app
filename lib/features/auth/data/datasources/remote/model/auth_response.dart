import 'user_dto.dart';

class AuthResponse {
  final String token;
  final UserDto user;
  const AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    token: json['data']['token'],
    user: UserDto.fromJson(json['data']['user']),
  );
}