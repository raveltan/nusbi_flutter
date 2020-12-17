import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/student/get_profile_model.dart';
import 'package:nusbi_flutter/model/models/teacher/get_teacher_profile_model.dart';

class TeacherProfilePage extends StatefulWidget {
  @override
  _TeacherProfilePageState createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  GetTeacherProfileResponse _data = GetTeacherProfileResponse();

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  bool _isLoading = true;

  void getProfile() async {
    setState(() {
      _isLoading = true;
    });
    var result = await ModelService()
        .doAuthRequest(GetTeacherProfileRequest(ModelService().username));

    if (result is String) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
            title: Text('Error'),
            content: Text(result),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () => Navigator.of(x).pop(),
              )
            ],
          ));
      return;
    }
    _data = result as GetTeacherProfileResponse;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('User Profile'),
      ),
      body: Stack(children: [
        Center(
          child: _isLoading ? Container() : Container(
            constraints: BoxConstraints(maxWidth: 700),
            child: Scrollbar(
              radius: Radius.circular(30),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_circle,
                            size: 64,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _data.firstName + ' ' + _data.lastName,
                                  style: TextStyle(fontSize: 26),
                                ),
                                Text('@${ModelService().username}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Text(
                            _data.gender == 'M' ? 'Male' : 'Female',
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                      ListTile(
                        title: Text("Email"),
                        trailing: Text(_data.email,style:TextStyle(fontWeight:FontWeight.bold)),
                      ),
                      ListTile(
                        title: Text("Date of birth"),
                        trailing: Text(_data.dOB,style:TextStyle(fontWeight:FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _isLoading
            ? Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black.withOpacity(0.4),
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16,
                ),
                CircularProgressIndicator(),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Please wait',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          ),
        )
            : Container(),
      ]),
    );
  }
}
