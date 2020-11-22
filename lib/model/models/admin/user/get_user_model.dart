import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class GetUserRequest extends AuthRequestBase<GetUserResponse>{
  @override
  Future doAuthRequest(String token)async {
    http.Response res;
    try {
      res = await http.get(apiUrl,
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    } catch (e) {
      error = 'Unable to connect to server';
      return;
    }
    if(res.body == "Invalid or expired JWT"){
      doRefreshToken = true;
      return;
    }
    if (res.statusCode == 403) {
      error = "Access denied";
      return;
    }else if(res.statusCode != 200){
      error = "Server error";
      return;
    }
    try {
      response = GetUserResponse.fromJson(jsonDecode(res.body));
    } catch (e) {
      error = "Bad response";
      return;
    }
  }

  @override
  Future doRequest() {
    // TODO: implement doRequest
    throw UnimplementedError();
  }

  @override
  void setApiUrl(String url) => apiUrl = url + "/admin/user/";

}

class GetUserResponse {
  List<UserResponseData> data;

  GetUserResponse({this.data});

  GetUserResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<UserResponseData>();
      json['data'].forEach((v) {
        data.add(new UserResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserResponseData {
  String username;
  String role;

  UserResponseData({this.username, this.role});

  UserResponseData.fromJson(Map<String, dynamic> json) {
    username = json['Username'];
    role = json['Role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Username'] = this.username;
    data['Role'] = this.role;
    return data;
  }
}