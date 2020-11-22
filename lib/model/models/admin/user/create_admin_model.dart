import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class CreateAdminRequest extends AuthRequestBase<CreateAdminResponse> {
  String username;
  String password;

  CreateAdminRequest(this.username, this.password);

  @override
  void setApiUrl(String url) => apiUrl = url + '/admin/user/createAdmin';

  @override
  Future doAuthRequest(String token) async {
    if (username.length < 5) {
      error = "Username should at least be 5 character";
      return;
    }
    if (password.length < 8) {
      error = "Password should at least be 8 character";
      return;
    }
    http.Response res;
    try {
      res = await http.post(apiUrl,
          body: {"Username": username, "Password": password},
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    } catch (e) {
      error = 'Unable to connect to server';
      return;
    }
    if (res.body == "Invalid or expired JWT") {
      doRefreshToken = true;
      return;
    }
    if (res.statusCode != 200) {
      error = "Server error";
      return;
    }
    try {
      response = CreateAdminResponse.fromJson(jsonDecode(res.body));
    } catch (e) {
      error = "Bad response";
      return;
    }
    if (response.error == 5) {
      error = "Username exists";
      return;
    }
    if (response.error != -1) {
      error = "Unknown error";
      return;
    }
  }

  @override
  Future doRequest() {
    // TODO: implement doRequest
    throw UnimplementedError();
  }
}

class CreateAdminResponse {
  int error;

  CreateAdminResponse({this.error});

  CreateAdminResponse.fromJson(Map<String, dynamic> json) {
    error = json['Error'];
  }
}
