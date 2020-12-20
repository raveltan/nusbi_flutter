import 'dart:convert';
import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class GetProfileRequest extends AuthRequestBase<GetProfileResponse> {
  String id;

  GetProfileRequest(this.id);

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
      response = GetProfileResponse.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
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
  void setApiUrl(String url) => apiUrl = url + '/student/profile';
}

class GetProfileResponse {
  String firstName;
  String lastName;
  String gender;
  String dOB;
  String email;
  GPA gPA;
  SCU sCU;
  String major;

  GetProfileResponse(
      {this.firstName,
      this.lastName,
      this.gender,
      this.dOB,
      this.email,
      this.gPA,
      this.sCU,
      this.major});

  GetProfileResponse.fromJson(Map<String, dynamic> json) {
    firstName = json['FirstName'];
    lastName = json['LastName'];
    gender = json['Gender'];
    dOB = json['DOB'];
    email = json['Email'];
    gPA = json['GPA'] != null ? new GPA.fromJson(json['GPA']) : null;
    sCU = json['SCU'] != null ? new SCU.fromJson(json['SCU']) : null;
    major = json['Major'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Gender'] = this.gender;
    data['DOB'] = this.dOB;
    data['Email'] = this.email;
    if (this.gPA != null) {
      data['GPA'] = this.gPA.toJson();
    }
    if (this.sCU != null) {
      data['SCU'] = this.sCU.toJson();
    }
    data['Major'] = this.major;
    return data;
  }
}

class GPA {
  double int32;
  bool valid;


  GPA.fromJson(Map<String, dynamic> json) {
    int32 = json['Float64'];
    valid = json['Valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Int32'] = this.int32;
    data['Valid'] = this.valid;
    return data;
  }
}

class SCU {
  int int32;
  bool valid;

  SCU.fromJson(Map<String, dynamic> json) {
    int32 = json['Int32'];
    valid = json['Valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Int32'] = this.int32;
    data['Valid'] = this.valid;
    return data;
  }
}
