import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class SetStudentMidScoreRequest extends AuthRequestBase {
  String studentId;
  String classId;
  int score;

  SetStudentMidScoreRequest(this.studentId, this.classId, this.score);

  @override
  Future doAuthRequest(String token) async {
    if (studentId == "" || classId == "" || score < 0) {
      error = "Invalid data";
      return;
    }
    http.Response res;
    try {
      res = await http.post(apiUrl, body: {
        "ClassID": classId,
        "StudentID": studentId,
        "MidScore": score.toString()
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token"
      });
    } catch (e) {
      error = 'Unable to connect to server';
      return;
    }
    if (res.statusCode != 200) {
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
  void setApiUrl(String url) => apiUrl = url + '/teacher/student/mid';
}
