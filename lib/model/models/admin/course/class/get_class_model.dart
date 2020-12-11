import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class GetClassRequest extends AuthRequestBase<GetClassResponse>{
  String id;
  GetClassRequest(this.id);
  @override
  Future doAuthRequest(String token) async {
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
      response = GetClassResponse.fromJson(jsonDecode(res.body));
    } catch (e) {
      error = "Bad response";
      return;
    }
  }

  @override
  void setApiUrl(String url) => apiUrl = url + "/admin/class";

  @override
  Future doRequest() {
    // TODO: implement doRequest
    throw UnimplementedError();
  }

}

class GetClassResponse {
  List<ClassData> data;

  GetClassResponse({this.data});

  GetClassResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ClassData>();
      json['data'].forEach((v) {
        data.add(new ClassData.fromJson(v));
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

class ClassData {
  String className;
  int batch;
  String classID;


  ClassData.fromJson(Map<String, dynamic> json) {
    className = json['ClassName'];
    batch = json['Batch'];
    classID = json['ClassID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClassName'] = this.className;
    data['Batch'] = this.batch;
    data['ClassID'] = this.classID;
    return data;
  }
}