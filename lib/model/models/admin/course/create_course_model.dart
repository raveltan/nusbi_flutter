import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class CreateCourseRequest extends AuthRequestBase<CreateCourseResponse> {
  final String name;
  final String teacherID;
  final int scu;

  CreateCourseRequest({this.name, this.scu, this.teacherID});

  @override
  Future doAuthRequest(String token) async {
    if (name.length < 5) {
      error = "Course name should be at least 5 character";
      return;
    }
    if (scu < 0 || scu > 9) {
      error = "Scu should be between 1 and 9";
      return;
    }
    http.Response res;
    try {
      res = await http.post(apiUrl,
          body: {"Name": name, "TeacherID": teacherID, "Scu": scu.toString()},
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
      print(res.statusCode);
      error = "Server error";
      return;
    }
    try {
      response = CreateCourseResponse.fromJson(jsonDecode(res.body));
    } catch (e) {
      error = "Bad response";
      return;
    }
    if (response.error == 1) {
      error = "Access denied";
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
  void setApiUrl(String url) => apiUrl = url + '/admin/course';
}

class CreateCourseResponse {
  int error;

  CreateCourseResponse({this.error});

  CreateCourseResponse.fromJson(Map<String, dynamic> json) {
    error = json['Error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Error'] = this.error;
    return data;
  }
}
