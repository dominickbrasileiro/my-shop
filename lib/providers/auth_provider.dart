import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fshop/core/exceptions/auth_exception.dart';
import 'package:fshop/data/store.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _token;
  DateTime? _expirationDate;
  Timer? _logoutTimer;

  bool get isAuthenticated {
    return token != null;
  }

  String? get userId {
    return isAuthenticated ? _userId : null;
  }

  String? get token {
    if (_token != null &&
        _expirationDate != null &&
        _expirationDate!.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

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

    _userId = responseBody['localId'];
    _token = responseBody['idToken'];
    _expirationDate = DateTime.now().add(
      Duration(seconds: int.parse(responseBody['expiresIn'])),
    );

    await Store.saveMap('authData', {
      'token': _token!,
      'userId': _userId!,
      'expirationDate': _expirationDate!.toIso8601String(),
    });

    _autoLogout();
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    await _sendRequest(email, password, 'signInWithPassword');
  }

  Future<void> signUp(String email, String password) async {
    await _sendRequest(email, password, 'signUp');
  }

  Future<void> tryAutoLogin() async {
    if (isAuthenticated) {
      return null;
    }

    final authData = await Store.getMap('authData');

    if (authData == null) {
      return null;
    }

    final expirationDate = DateTime.parse(authData['expirationDate']);

    if (expirationDate.isBefore(DateTime.now())) {
      return null;
    }

    _userId = authData['userId'];
    _token = authData['token'];
    _expirationDate = expirationDate;

    _autoLogout();
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expirationDate = null;

    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
      _logoutTimer = null;
    }

    await Store.deleteKey('authData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
    }

    final timeToLogout = _expirationDate!.difference(DateTime.now()).inSeconds;

    _logoutTimer = Timer(
      Duration(seconds: timeToLogout),
      logout,
    );
  }
}
