import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class CreateMajorRequest extends AuthRequestBase<CreateMajorResponse> {
  String name;

  CreateMajorRequest(this.name);

  @override
  void setApiUrl(String url) => apiUrl = url + '/admin/major/';

  @override
  Future doAuthRequest(String token) async {
    if (name.length < 3) {
      error = "Major name should at least be 3 character";
      return;
    }
    http.Response res;
    print("running");
    try {
      res = await http.post(apiUrl,
          body: {"Name": name},
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    } catch (e) {
      error = 'Unable to connect to server';
      return;
    }
    if(res.body == "Invalid or expired JWT"){
      doRefreshToken = true;
      return;
    }
    if (res.statusCode != 200) {
      error = "Server error";
      return;
    }
    try {
      response = CreateMajorResponse.fromJson(jsonDecode(res.body));
    } catch (e) {
      error = "Bad response";
      return;
    }
    if (response.error != -1){
      error = "Invalid data";
      return;
    }
  }

  @override
  Future doRequest() {
    // TODO: implement doRequest
    throw UnimplementedError();
  }
}

class CreateMajorResponse {
  int error;

  CreateMajorResponse({this.error});

  CreateMajorResponse.fromJson(Map<String, dynamic> json) {
    error = json['Error'];
  }
}
