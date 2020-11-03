import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nusbi_flutter/model/request_base.dart';

class ModelService {
  static final ModelService _modelService = ModelService._internal();

  factory ModelService() => _modelService;

  // TODO: change to production api endpoint
  static const String _baseUrl = 'http://10.0.2.2:8080';

  final _storage = FlutterSecureStorage();
  var _isLogin = false;
  var _token = '';
  var _refresh = '';
  var userRole ='';
  var username = '';

  ModelService._internal();

  Future<bool> getToken() async {
    await Future.delayed(Duration(seconds: 1));
    var token = await _storage.read(key: 'token');
    var refresh = await _storage.read(key: 'refresh');
    var role = await _storage.read(key: 'role');
    var username = await _storage.read(key: 'username');
    if (token != null && refresh != null && role != null && username != null) {
      _token = token;
      _refresh = refresh;
      userRole = role;
      _isLogin = true;
      this.username = username;
    } else {
      _isLogin = false;
    }
    return _isLogin;
  }

  Future<void> logout() async => await _storage.deleteAll();

  Future<void> setToken(String token, String refresh,String role,String user) async {
    _isLogin = true;
    _token = token;
    _refresh = refresh;
    this.username = user;
    userRole = role;
    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'role', value: role);
    await _storage.write(key: 'refresh', value: refresh);
    await _storage.write(key: 'username', value: user);
  }

  Future doAuthRequest(AuthRequestBase request, {int retry = 0}) async {
    request.setApiUrl(_baseUrl);
    request.doAuthRequest(_token);
    if (request.doRefreshToken && retry < 3) {
      // TODO: Refresh the token
      await doAuthRequest(request, retry: retry + 1);
      return request.response;
    } else if (retry > 2) {
      return null;
    }
    if (request.error == "") {
      return request.response;
    } else {
      return request.error;
    }
  }

  Future doRequest(RequestBase request) async {
    request.setApiUrl(_baseUrl);
    await request.doRequest();
    if (request.error == "") {
      return request.response;
    } else {
      return request.error;
    }
  }
}
