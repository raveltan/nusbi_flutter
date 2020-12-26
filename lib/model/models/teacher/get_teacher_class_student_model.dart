import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart'as http;

import '../../model_service.dart';

class GetClassStudentRequest extends AuthRequestBase<GetClassStudentResponse>{
  String classID;
  GetClassStudentRequest(this.classID);
  @override
  Future doAuthRequest(String token) async {
    http.Response res;
    try {
      res = await http.get(apiUrl + '/$classID',
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
      response = GetClassStudentResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + '/teacher/class';

}

class GetClassStudentResponse {
  List<ClassStudentData> classStudentData;

  GetClassStudentResponse({this.classStudentData});

  GetClassStudentResponse.fromJson(Map<String, dynamic> json) {
    if (json['ClassStudentData'] != null) {
      classStudentData = new List<ClassStudentData>();
      json['ClassStudentData'].forEach((v) {
        classStudentData.add(new ClassStudentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.classStudentData != null) {
      data['ClassStudentData'] =
          this.classStudentData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClassStudentData {
  String studentID;
  String name;
  int midScore;
  int finalScore;

  ClassStudentData({this.studentID, this.name, this.midScore, this.finalScore});

  ClassStudentData.fromJson(Map<String, dynamic> json) {
    studentID = json['StudentID'];
    name = json['Name'];
    midScore = json['MidScore'];
    finalScore = json['FinalScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StudentID'] = this.studentID;
    data['Name'] = this.name;
    data['MidScore'] = this.midScore;
    data['FinalScore'] = this.finalScore;
    return data;
  }
}