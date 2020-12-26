import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

import '../../model_service.dart';

class GetTeacherCourseRequest extends AuthRequestBase<GetTeacherCourseResponse>{
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
      response = GetTeacherCourseResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + '/teacher/course';

}
class GetTeacherCourseResponse {
  List<TeacherCourseData> teacherCourseData;

  GetTeacherCourseResponse({this.teacherCourseData});

  GetTeacherCourseResponse.fromJson(Map<String, dynamic> json) {
    if (json['TeacherCourseData'] != null) {
      teacherCourseData = new List<TeacherCourseData>();
      json['TeacherCourseData'].forEach((v) {
        teacherCourseData.add(new TeacherCourseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teacherCourseData != null) {
      data['TeacherCourseData'] =
          this.teacherCourseData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeacherCourseData {
  String className;
  String courseName;
  String classID;
  int sCU;

  TeacherCourseData({this.className, this.courseName, this.classID, this.sCU});

  TeacherCourseData.fromJson(Map<String, dynamic> json) {
    className = json['ClassName'];
    courseName = json['CourseName'];
    classID = json['ClassID'];
    sCU = json['SCU'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClassName'] = this.className;
    data['CourseName'] = this.courseName;
    data['ClassID'] = this.classID;
    data['SCU'] = this.sCU;
    return data;
  }
}