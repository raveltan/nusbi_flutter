import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class CreateStudentRequest extends AuthRequestBase<CreateStudentResponse> {
  final String username;
  final String password;
  final String batch;
  final String major;
  final String firstName;
  final String lastName;
  final String gender;
  final String DOB;
  final String email;

  CreateStudentRequest(
      {this.password,
      this.username,
      this.batch,
      this.DOB,
      this.email,
      this.firstName,
      this.gender,
      this.lastName,
      this.major});

  @override
  Future doAuthRequest(String token) async {
    if (firstName.length < 3 || lastName.length < 3) {
      error = "First name and last name should be at least 3 characters";
      return;
    }
    if (username.length < 5) {
      error = "Username should be at least 5 characters";
      return;
    }
    if (password.length < 8) {
      error = "Password should be at least 8 characters";
      return;
    }
    http.Response res;
    try {
      res = await http.post(apiUrl, body: {
        "Username": username,
        "Password": password,
        "Batch": batch,
        "FirstName": firstName,
        "LastName": lastName,
        "Gender": gender,
        "Dob": DOB,
        "Email": email,
        "Major": major
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token"
      });
    } catch (e) {
      error = 'Unable to connect to server';
      return;
    }
    if (res.body == "Invalid or expired JWT") {
      doRefreshToken = true;
      return;
    }
    if (res.statusCode != 200) {
      print(res.statusCode);
      error = "Server error";
      return;
    }
    try {
      response = CreateStudentResponse.fromJson(jsonDecode(res.body));
    } catch (e) {
      error = "Bad response";
      return;
    }
    if (response.error == 1) {
      error = "Access denied";
      return;
    } else if (response.error == 2) {
      error = "Request error";
      return;
    } else if (response.error == 3) {
      error = "Short username";
      return;
    } else if (response.error == 4) {
      error = "Short password";
      return;
    } else if (response.error == 5) {
      error = "Duplicate user";
      return;
    } else if (response.error != -1) {
      error = "Unknown error";
      return;
    }
  }

  @override
  Future doRequest() {
    // TODO: implement doRequest
    throw UnimplementedError();
  }

  @override
  void setApiUrl(String url) => apiUrl = url + '/admin/user/createStudent';
}

class CreateStudentResponse {
  int error;

  CreateStudentResponse({this.error});

  CreateStudentResponse.fromJson(Map<String, dynamic> json) {
    error = json['Error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Error'] = this.error;
    return data;
  }
}
