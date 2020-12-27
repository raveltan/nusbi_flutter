import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart'as http;

class GetStudentAbsenceRequest extends AuthRequestBase<GetStudentAbsenceResponse>{
  String scheduleID;
  String uid;
  GetStudentAbsenceRequest(this.scheduleID,this.uid);
  @override
  Future doAuthRequest(String token) async {
    http.Response res;
    try {
      res = await http.get(apiUrl + '/$scheduleID/$uid',
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
      response = GetStudentAbsenceResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + '/teacher/student/absenceData';

}

class GetStudentAbsenceResponse {
  int absence;

  GetStudentAbsenceResponse({this.absence});

  GetStudentAbsenceResponse.fromJson(Map<String, dynamic> json) {
    absence = json['Absence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Absence'] = this.absence;
    return data;
  }
}