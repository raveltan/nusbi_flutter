import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class GetTeacherProfileRequest extends AuthRequestBase<GetTeacherProfileResponse>{
  String id;
  GetTeacherProfileRequest(this.id);
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
      response = GetTeacherProfileResponse.fromJson(jsonDecode(res.body));
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
  void setApiUrl(String url) => apiUrl = url + '/teacher/profile';

}

class GetTeacherProfileResponse {
  String firstName;
  String lastName;
  String dOB;
  String gender;
  String email;

  GetTeacherProfileResponse(
      {this.firstName, this.lastName, this.dOB, this.gender, this.email});

  GetTeacherProfileResponse.fromJson(Map<String, dynamic> json) {
    firstName = json['FirstName'];
    lastName = json['LastName'];
    dOB = json['DOB'];
    gender = json['Gender'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['DOB'] = this.dOB;
    data['Gender'] = this.gender;
    data['Email'] = this.email;
    return data;
  }
}