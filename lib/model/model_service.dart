import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nusbi_flutter/model/models/auth/refresh_token_model.dart';
import 'package:nusbi_flutter/model/request_base.dart';

class ModelService {
  static final ModelService _modelService = ModelService._internal();

  factory ModelService() => _modelService;

  // TODO: change to production api endpoint
  static const String _baseUrl = 'http://127.0.0.1:8080';

  Box _storage;
  var _isLogin = false;
  var _token = '';
  var _refresh = '';
  var userRole = '';
  var username = '';

  ModelService._internal();

  Future<void> initBox() async => _storage = await Hive.openBox("token");

  Future<bool> getToken() async {
    if (_storage == null) {
      await Hive.initFlutter();
      await initBox();
    }
    await Future.delayed(Duration(seconds: 1));
    var token = _storage.get('token');
    var refresh = _storage.get('refresh');
    var role = _storage.get('role');
    var username = _storage.get('username');
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

  Future<void> logout() async => await _storage.clear();

  Future<void> setToken(
      String token, String refresh, String role, String user) async {
    _isLogin = true;
    _token = token;
    _refresh = refresh;
    this.username = user;
    userRole = role;
    await _storage.put('token', token);
    await _storage.put('role', role);
    await _storage.put('refresh', refresh);
    await _storage.put('username', user);
  }

  Future<void> _refreshToken() async{
    var ins = TokenRefreshRequest();
    ins.setApiUrl(_baseUrl);
    await ins.doAuthRequest(_refresh);
    if (ins.error == "" || ins.error == null){
      var res = ins.response;
      await _storage.put('token', res.token);
      await _storage.put('refresh',res.refresh);
      _token = res.token;
      _refresh = res.refresh;
    }
  }

  Future doAuthRequest(AuthRequestBase request, {int retry = 0}) async {
    request.setApiUrl(_baseUrl);
    request.doRefreshToken = false;
    await request.doAuthRequest(_token);
    if (request.doRefreshToken && retry < 2){
      await _refreshToken();
      return await doAuthRequest(request, retry: retry + 1);
    } else if (retry >= 2) {
      return "Unable to refresh token, try signin in again";
    }
    if (request.error == "") {
      return request.response;
    }
    return request.error;
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
