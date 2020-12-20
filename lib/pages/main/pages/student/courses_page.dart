import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/student/get_student_course_model.dart';

class CoursesPage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursesPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }
  List<StudentCourseResponse> _data = [];
  void getData() async {
    setState(() {
      _isLoading = true;
    });
    var result = await ModelService().doAuthRequest(GetStudentCourseRequest());

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
    _data = (result as GetStudentCourseResponse).data ?? [];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('Courses'),
      ),
      body: Stack(
        children: [Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            child: Scrollbar(
              radius: Radius.circular(30),
              child: ListView.separated(
                  itemBuilder: (x, index) => ListTile(
                        title: Text(_data[index].name),
                        subtitle: Text(_data[index].teacherName),
                        isThreeLine: false,
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepOrangeAccent.shade100,
                          foregroundColor: Colors.white,
                          child: Text(_data[index].sCU.toString()),
                        ),
                      ),
                  separatorBuilder: (ctx, index) => Divider(),
                  itemCount: _data.length),
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
        ]
      ),
    );
  }
}
