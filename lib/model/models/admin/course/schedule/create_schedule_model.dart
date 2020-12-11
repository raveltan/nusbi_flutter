import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;
class CreateScheduleRequest extends AuthRequestBase{
  String date;
  String id;
  CreateScheduleRequest(this.date,this.id);
  @override
  Future doAuthRequest(String token) async {
    if(date == null || date == ""){
      error = "Date cannot be empty";
      return;
    }
    http.Response res;
    try {
      res = await http.post(apiUrl,
          body: {
            "Date":date,
            "ClassID":id,
          },
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    } catch (e) {
      print(e);
      error = 'Unable to connect to server';
      return;
    }
    if (res.body == "Invalid or expired JWT") {
      doRefreshToken = true;
      return;
    }
    if(res.statusCode == 403){
      error = "Access denied";
      return;
    }
    if (res.statusCode != 200) {
      print(res.statusCode);
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
  void setApiUrl(String url) => apiUrl = url + "/admin/schedule";

}