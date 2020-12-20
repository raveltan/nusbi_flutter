import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

import '../../model_service.dart';

class GetTeacherScheduleRequest extends AuthRequestBase<GetTeacherScheduleResponse>{
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
      response = GetTeacherScheduleResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + '/teacher/schedule';

}

class GetTeacherScheduleResponse {
  List<TeacherScheduleResult> teacherScheduleResult;



  GetTeacherScheduleResponse.fromJson(Map<String, dynamic> json) {
    if (json['TeacherScheduleResult'] != null) {
      teacherScheduleResult = new List<TeacherScheduleResult>();
      json['TeacherScheduleResult'].forEach((v) {
        teacherScheduleResult.add(new TeacherScheduleResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teacherScheduleResult != null) {
      data['TeacherScheduleResult'] =
          this.teacherScheduleResult.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeacherScheduleResult {
  String date;
  String course;
  String className;

  TeacherScheduleResult({this.date, this.course, this.className});

  TeacherScheduleResult.fromJson(Map<String, dynamic> json) {
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