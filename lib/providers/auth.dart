import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;
  String _userEmail;
  String _userName;

  String get token => _token;
  String get userId => _userId;
  String get userEmail => _userEmail;
  String get userName => _userName;

  bool get isAuthenticated => token != null;

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$API_URL/login'),
        body: {
          'email': email,
          'password': password,
          'device_name': await getDeviceName(),
        },
        headers: {'Accept': 'application/json'},
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw Exception(responseData['message']);
      }

      _token = responseData['token'];
      _userId = responseData['user_id'].toString();
      _userEmail = responseData['user_email'];
      _userName = responseData['user_name'];

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId.toString(),
        'token': _token,
        'userEmail': _userEmail,
        'userName': _userName,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$API_URL/register'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  getDeviceName() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.androidId + '|' + build.model + '|' + build.brand;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  Future<bool> tryAutoLogin() async {

    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _userEmail = extractedUserData['userEmail'];
    _userName = extractedUserData['userName'];

    notifyListeners();

    print(_token);

    return true;
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    _userEmail = null;
    _userName = null;

    final prefs = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    var token = extractedUserData['token'];

    prefs.clear();

    final response = await http.post(
      Uri.parse('$API_URL/logout'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 401) {} else {
      throw Exception('Failed to clear token.');
    }

    notifyListeners();
  }
}
