import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class TokenRefreshRequest extends AuthRequestBase<TokenRefreshResponse> {
  @override
  Future doRequest() async {
    return;
  }

  @override
  void setApiUrl(String url) => apiUrl = url + '/refresh/';

  @override
  Future doAuthRequest(String token) async {
    http.Response res;
    try {
      res = await http.post(apiUrl,
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    } catch (e) {
      print(e);
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
      response = TokenRefreshResponse.fromJson(jsonDecode(res.body));
      doRefreshToken = false;
    } catch (e) {
      error = "Bad response";
      return;
    }
  }
}

class TokenRefreshResponse {
  String token;
  String refresh;

  TokenRefreshResponse({this.token, this.refresh});

  TokenRefreshResponse.fromJson(Map<String, dynamic> json) {
    token = json['Token'];
    refresh = json['Refresh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Token'] = this.token;
    data['Refresh'] = this.refresh;
    return data;
  }
}
