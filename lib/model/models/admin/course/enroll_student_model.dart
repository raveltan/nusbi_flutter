import 'dart:io';

import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class EnrollStudentRequest extends AuthRequestBase {
  String classId;
  String username;

  EnrollStudentRequest(this.classId, this.username);

  @override
  Future doAuthRequest(String token) async {
    http.Response res;
    try {
      res = await http.post(apiUrl,
          body: {"Username": username, "ClassID": classId},
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    } catch (e) {
      error = 'Unable to connect to server';
      return;
    }
    if (res.body == "Invalid or expired JWT") {
      doRefreshToken = true;
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
  void setApiUrl(String url) => apiUrl = url + '/admin/enroll';
}
