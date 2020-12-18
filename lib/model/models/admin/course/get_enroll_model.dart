import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http ;

class GetEnrolledRequest extends AuthRequestBase {
  String id;
  GetEnrolledRequest(this.id);
  @override
  Future doAuthRequest(String token) async  {
    http.Response res;
    try {
      res = await http.get(apiUrl + '/$id',
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
      response = GetEnrolledResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + '/admin/enroll';
}

class GetEnrolledResponse {
  List<EnrollResponse> data;

  GetEnrolledResponse({this.data});

  GetEnrolledResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<EnrollResponse>();
      json['data'].forEach((v) {
        data.add(new EnrollResponse.fromJson(v));
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

class EnrollResponse {
  String className;
  String courseName;
  String classID;

  EnrollResponse({this.className, this.courseName, this.classID});

  EnrollResponse.fromJson(Map<String, dynamic> json) {
    className = json['ClassName'];
    courseName = json['CourseName'];
    classID = json['ClassID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClassName'] = this.className;
    data['CourseName'] = this.courseName;
    data['ClassID'] = this.classID;
    return data;
  }
}
