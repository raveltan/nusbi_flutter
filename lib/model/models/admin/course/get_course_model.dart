
import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class GetCourseRequest extends AuthRequestBase<GetCourseResponse>{
  @override
  Future doAuthRequest(String token) async {
    http.Response res;
    try {
      res = await http.get(apiUrl,
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    } catch (e) {
      error = 'Unable to connect to server';
      return;
    }
    if(res.body == "Invalid or expired JWT"){
      doRefreshToken = true;
      return;
    }
    if (res.statusCode == 403) {
      error = "Access denied";
      return;
    }else if(res.statusCode != 200){
      error = "Server error";
      return;
    }
    try {
      response = GetCourseResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + '/admin/course';

}


class GetCourseResponse {
  List<GetCourseResponseData> data;

  GetCourseResponse({this.data});

  GetCourseResponse.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = new List<GetCourseResponseData>();
      json['Data'].forEach((v) {
        data.add(new GetCourseResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetCourseResponseData {
  String courseID;
  String name;
  int scu;
  String teacherName;

  GetCourseResponseData({this.courseID, this.name, this.scu, this.teacherName});

  GetCourseResponseData.fromJson(Map<String, dynamic> json) {
    courseID = json['CourseID'];
    name = json['Name'];
    scu = json['Scu'];
    teacherName = json['TeacherName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CourseID'] = this.courseID;
    data['Name'] = this.name;
    data['Scu'] = this.scu;
    data['TeacherName'] = this.teacherName;
    return data;
  }
}