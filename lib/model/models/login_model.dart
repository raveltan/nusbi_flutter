import 'dart:convert';
import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class LoginRequest extends RequestBase<LoginResponse> {
  @override
  void setApiUrl(String url) => apiUrl = url + '/login';

  String username;
  String password;
  LoginRequest(this.username,this.password);

  @override
  Future<void> doRequest() async {
    if(username.length < 5){
      error = "Username should be at least 5 characters";
      return;
    }
    if(password.length < 8){
      error = "Password should be at least 8 characters";
      return;
    }
    http.Response res;
    try{
      res = await http.post(apiUrl,body: {
        "Username":username,
        "Password":password,
      });
    }
    catch(e){
      error = 'Unable to connect to server';
      return;
    }
    if (res.statusCode != 200) {
      error = "Server error";
      return;
    }
    try {
      response = LoginResponse.fromJson(jsonDecode(res.body));
    } catch (e) {
      error = "Server error";
      return;
    }
    switch (response.error) {
      case 1:
        {
          error = "Invalid request";
          break;
        }
      case 2:
        {
          error = "Username and password should be at least 5 and 8 character";
          break;
        }
      case 3:
        {
          error = "User not found or wrong credentials";
          break;
        }
      case -1:
        {
          error = "";
          break;
        }
      default:{
        error = "Unknown error";
        break;
      }
    }
  }
}

class LoginResponse {
  String token;
  String refresh;
  int error;
  String role;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['Token'];
    refresh = json['Refresh'];
    error = json['Error'];
    role = json['Role'];
  }
}
