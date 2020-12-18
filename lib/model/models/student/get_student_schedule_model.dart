import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

import '../../model_service.dart';
class GetStudentScheduleRequest extends AuthRequestBase<GetStudentScheduleResponse>{
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
      response = GetStudentScheduleResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + '/student/schedule';
}

class GetStudentScheduleResponse {
  List<StudentScheduleResponse> studentScheduleResponse;

  GetStudentScheduleResponse({this.studentScheduleResponse});

  GetStudentScheduleResponse.fromJson(Map<String, dynamic> json) {
    if (json['StudentScheduleResponse'] != null) {
      studentScheduleResponse = new List<StudentScheduleResponse>();
      json['StudentScheduleResponse'].forEach((v) {
        studentScheduleResponse.add(new StudentScheduleResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.studentScheduleResponse != null) {
      data['StudentScheduleResponse'] =
          this.studentScheduleResponse.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentScheduleResponse {
  String date;
  String course;
  String className;

  StudentScheduleResponse({this.date, this.course, this.className});

  StudentScheduleResponse.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    course = json['Course'];
    className = json['ClassName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['Course'] = this.course;
    data['ClassName'] = this.className;
    return data;
  }
}