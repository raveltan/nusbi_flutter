import 'dart:io';

import 'package:http/http.dart'as http;
import 'package:nusbi_flutter/model/request_base.dart';

class SetStudentAbsenceRequest extends AuthRequestBase{
  String studentID;
  String scheduleID;
  bool attend;
  SetStudentAbsenceRequest(this.studentID,this.scheduleID,this.attend);
  @override
  Future doAuthRequest(String token) async  {
    http.Response res;
    try {
      res = await http.post(apiUrl, body: {
        "StudentID": studentID,
        "ScheduleID": scheduleID,
        "Attend": attend.toString()
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token"
      });
    } catch (e) {
      error = 'Unable to connect to server';
      return;
    }

    if (res.statusCode != 200) {
      error = "Server error";
      return;
    }
  }

  @override
  Future doRequest() {
    // TODO: implement doRequest
    throw UnimplementedError();
  }

  @override
  void setApiUrl(String url) => apiUrl = url + '/teacher/student/absence/';

}