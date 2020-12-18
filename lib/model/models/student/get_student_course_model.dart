import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class GetStudentCourseRequest
    extends AuthRequestBase<GetStudentCourseResponse> {

  @override
  Future doAuthRequest(String token) async {
    http.Response res;
    try {
      res = await http.get(apiUrl + '/${ModelService().username}',
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    } catch (e) {
      error = 'Unable to connect to server';
      return;
    }
    if (res.body == "Invalid or expired JWT") {
      doRefreshToken = true;
      return;
    }
    if (res.statusCode == 403) {
      error = "Access denied";
      return;
    } else if (res.statusCode != 200) {
      error = "Server error";
      return;
    }
    try {
      response = GetStudentCourseResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + '/student/course';
}

class GetStudentCourseResponse {
  List<StudentCourseResponse> data;

  GetStudentCourseResponse({this.data});

  GetStudentCourseResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<StudentCourseResponse>();
      json['data'].forEach((v) {
        data.add(new StudentCourseResponse.fromJson(v));
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

class StudentCourseResponse {
  String name;
  String teacherName;
  int sCU;

  StudentCourseResponse({this.name, this.teacherName, this.sCU});

  StudentCourseResponse.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    teacherName = json['TeacherName'];
    sCU = json['SCU'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['TeacherName'] = this.teacherName;
    data['SCU'] = this.sCU;
    return data;
  }
}
