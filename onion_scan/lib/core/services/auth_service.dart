import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:8000'; // Ajuste selon ton serveur

  Future<User?> signup({
    required String fullName,
    required String emailOrPhone,
    required String password,
    required String gender,
    required String userType,
    required String region,
    required String province,
    required String department,
    required String cityVillage,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': fullName,
          'email': emailOrPhone.contains('@') ? emailOrPhone : null,
          'phoneNumber': emailOrPhone.contains('@') ? null : emailOrPhone,
          'password': password,
          'gender': gender,
          'userType': userType,
          'region': region,
          'province': province,
          'department': department,
          'cityVillage': cityVillage,
        }),
      );
      if (response.statusCode == 201) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to signup: ${response.body}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> login(String emailOrPhone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': emailOrPhone,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> forgotPassword(String emailOrPhone) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email_or_phone': emailOrPhone}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}