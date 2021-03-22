import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;
  final baseUrl = 'http://10.0.2.2:8000/';

  String get token => _token;

  String get userId => _userId;

  bool get isAuthenticated => token != null;

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        baseUrl + 'api/login',
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
      _userId = responseData['user_id'];

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId,
        'token': _token,
      });
      prefs.setString('userData', userData);
    } catch (error) {
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
}
