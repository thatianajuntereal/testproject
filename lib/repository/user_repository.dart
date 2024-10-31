import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> login(String username, String otp) async {
  final url = Uri.parse('https://indexcodex.com/api/v1/login');
  final headers = {
    'CLIENT_ID': 'rgbexam',
    'Content-Type': 'application/json',
  };
  final body = jsonEncode({
    'userName': username,
    'otp': otp,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
    } else {
      print('Error: ${response.statusCode} ${response.body}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}
