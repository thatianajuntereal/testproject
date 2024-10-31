import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  String statusMessage = "";

  Future<void> login(String userName, String otp) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://indexcodex.com/api/v1/login');
    final headers = {
      'CLIENT_ID': 'rgbexam',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final body = {
      'userName': userName,
      'otp': otp,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['loginStatus'] == 'success') {
          statusMessage = "Login Successful";
        } else {
          statusMessage = "Login Failed. Incorrect login status.";
        }
      } else {
        statusMessage = "Login Failed with status code ${response.statusCode}.";
      }
    } catch (e) {
      statusMessage = "An error occurred. Please check your connection.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
