import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart'as http;

import '../../model_service.dart';

class GetStudentAbsenceRecordRequest extends AuthRequestBase<GetStudentAbsenceRecordResponse>{
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
      response = GetStudentAbsenceRecordResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + '/student/absence';

}

class GetStudentAbsenceRecordResponse {
  List<GetStudentAbsentRecordData> getStudentAbsentRecordData;

  GetStudentAbsenceRecordResponse({this.getStudentAbsentRecordData});

  GetStudentAbsenceRecordResponse.fromJson(Map<String, dynamic> json) {
    if (json['GetStudentAbsentRecordData'] != null) {
      getStudentAbsentRecordData = new List<GetStudentAbsentRecordData>();
      json['GetStudentAbsentRecordData'].forEach((v) {
        getStudentAbsentRecordData
            .add(new GetStudentAbsentRecordData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.getStudentAbsentRecordData != null) {
      data['GetStudentAbsentRecordData'] =
          this.getStudentAbsentRecordData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetStudentAbsentRecordData {
  String className;
  String courseName;
  int absent;

  GetStudentAbsentRecordData({this.className, this.courseName, this.absent});

  GetStudentAbsentRecordData.fromJson(Map<String, dynamic> json) {
    className = json['ClassName'];
    courseName = json['CourseName'];
    absent = json['Absent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClassName'] = this.className;
    data['CourseName'] = this.courseName;
    data['Absent'] = this.absent;
    return data;
  }
}