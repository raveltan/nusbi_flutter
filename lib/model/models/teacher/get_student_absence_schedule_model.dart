import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;
class GetStudentAbsenceScheduleRequest extends AuthRequestBase<GetStudentAbsenceScheduleResponse>{
  String classID;
  String uid;
  GetStudentAbsenceScheduleRequest(this.classID,this.uid);
  @override
  Future doAuthRequest(String token) async {
    http.Response res;
    try {
      res = await http.get(apiUrl + '/$classID/$uid',
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
      response = GetStudentAbsenceScheduleResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + '/teacher/student/absence';

}

class GetStudentAbsenceScheduleResponse {
  List<StudentAbsenceScheduleData> studentAbsenceScheduleData;

  GetStudentAbsenceScheduleResponse({this.studentAbsenceScheduleData});

  GetStudentAbsenceScheduleResponse.fromJson(Map<String, dynamic> json) {
    if (json['StudentAbsenceScheduleData'] != null) {
      studentAbsenceScheduleData = new List<StudentAbsenceScheduleData>();
      json['StudentAbsenceScheduleData'].forEach((v) {
        studentAbsenceScheduleData
            .add(new StudentAbsenceScheduleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.studentAbsenceScheduleData != null) {
      data['StudentAbsenceScheduleData'] =
          this.studentAbsenceScheduleData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentAbsenceScheduleData {
  String date;
  String scheduleID;

  StudentAbsenceScheduleData({this.date, this.scheduleID});

  StudentAbsenceScheduleData.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    scheduleID = json['ScheduleID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['ScheduleID'] = this.scheduleID;
    return data;
  }
}