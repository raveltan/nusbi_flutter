import 'dart:io';

import 'package:nusbi_flutter/model/request_base.dart';
import 'package:http/http.dart' as http;

class CreateClassRequest extends AuthRequestBase {
  @override
  Future doAuthRequest(String token) async {
    if(courseId.length < 4){
      error = "internal error";
      return;
    }
    if(className.length < 3){
      error = "Class name should be at least 3 characters";
      return;
    }
    int batchData = int.tryParse(batch) ?? -1;
    if(batchData < 2000){
      error = "Batch should be at least 2000";
      return;
    }
    http.Response res;
    try {
      res = await http.post(apiUrl,
          body: {
            "ClassName":className,
            "CourseID":courseId,
            "Batch":batchData.toString(),
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
  void setApiUrl(String url) => apiUrl = url + '/admin/class';

  String courseId;
  String className;
  String batch;
  CreateClassRequest(this.className,this.courseId,this.batch);

  @override
  Future doRequest() async {

  }
}
