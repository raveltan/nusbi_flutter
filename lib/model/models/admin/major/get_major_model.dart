import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class GetMajorRequest extends AuthRequestBase<GetMajorResponse>{
  @override
  Future doAuthRequest(String token)async {
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
      response = GetMajorResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + "/admin/major/";

}

class GetMajorResponse {
  List<MajorResponseData> data;

  GetMajorResponse({this.data});

  GetMajorResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<MajorResponseData>();
      json['data'].forEach((v) {
        data.add(new MajorResponseData.fromJson(v));
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

class MajorResponseData {
  String iD;
  String name;

  MajorResponseData({this.iD, this.name});

  MajorResponseData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    return data;
  }
}