import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiError implements Exception {
  final String message;
  final int? status;
  ApiError(this.message, {this.status});

  @override
  String toString() => message;
}

class TokenResponse {
  final String accessToken;
  final int userId;
  final String role;
  final int? agencyId;

  TokenResponse({
    required this.accessToken,
    required this.userId,
    required this.role,
    this.agencyId,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        accessToken: json['access_token'],
        userId: json['user_id'],
        role: json['role'],
        agencyId: json['agency_id'],
      );
}

class UserRead {
  final int id;
  final String email;
  final String? fullName;
  final String role;

  UserRead({
    required this.id,
    required this.email,
    this.fullName,
    required this.role,
  });

  factory UserRead.fromJson(Map<String, dynamic> json) => UserRead(
        id: json['id'],
        email: json['email'],
        fullName: json['full_name'],
        role: json['role'],
      );
}

class AuthService {
  final String baseUrl;

  AuthService({this.baseUrl = 'http://192.168.1.72:8000/api'});

  Future<TokenResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = TokenResponse.fromJson(data);
      // Guardar token local
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token.accessToken);
      await prefs.setString('role', token.role);
      if (token.agencyId != null) {
        await prefs.setInt('agency_id', token.agencyId!);
      }
      return token;
    } else {
      final error = jsonDecode(response.body);
      throw ApiError(error['detail'] ?? 'Error en login', status: response.statusCode);
    }
  }

  Future<UserRead> register(String email, String password, String fullName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'full_name': fullName,
        'role': 'agency_admin', // <--- asigna rol por defecto
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return UserRead.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw ApiError(error['detail'] ?? 'Error en registro', status: response.statusCode);
    }
  }

  Future<UserRead> me() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) throw ApiError('No token stored');

    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserRead.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw ApiError(error['detail'] ?? 'Error al obtener usuario', status: response.statusCode);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('role');
    await prefs.remove('agency_id');
  }
}
