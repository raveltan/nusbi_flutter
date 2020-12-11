import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class GetScheduleRequest extends AuthRequestBase<GetScheduleResponse>{
  String id;
  GetScheduleRequest(this.id);

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
      response = GetScheduleResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + '/admin/schedule';
  
}

class GetScheduleResponse {
  List<ScheduleData> data;

  GetScheduleResponse({this.data});

  GetScheduleResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ScheduleData>();
      json['data'].forEach((v) {
        data.add(new ScheduleData.fromJson(v));
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

class ScheduleData {
  String scheduleID;
  String date;

  ScheduleData.fromJson(Map<String, dynamic> json) {
    scheduleID = json['ScheduleID'];
    date = json['Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ScheduleID'] = this.scheduleID;
    data['Date'] = this.date;
    return data;
  }
}