import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fshop/core/exceptions/auth_exception.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  Future<void> _sendRequest(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBuIfQ6AqDqAoSM_YOsIqMmG13DCv7C7T8',
    );

    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final responseBody = json.decode(response.body);

    if (responseBody['error'] != null) {
      throw AuthException(responseBody['error']['message']);
    }
  }

  Future<void> login(String email, String password) async {
    await _sendRequest(email, password, 'signInWithPassword');
  }

  Future<void> signUp(String email, String password) async {
    await _sendRequest(email, password, 'signUp');
  }
}
