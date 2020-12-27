import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/teacher/get_student_absence_model.dart';
import 'package:nusbi_flutter/model/models/teacher/get_student_absence_schedule_model.dart';
import 'package:nusbi_flutter/model/models/teacher/set_student_absence_model.dart';

class TeacherClassAttendance extends StatefulWidget {
  String classId;
  String userId;
  TeacherClassAttendance(this.classId,this.userId);
  @override
  _TeacherClassAttendance createState() => _TeacherClassAttendance();
}

class _TeacherClassAttendance extends State<TeacherClassAttendance> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<StudentAbsenceScheduleData> _data = [];

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    var result = await ModelService().doAuthRequest(GetStudentAbsenceScheduleRequest(widget.classId, widget.userId));

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
    _data = (result as GetStudentAbsenceScheduleResponse).studentAbsenceScheduleData ?? [];
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> getSingleAttendance(String scheduleID) async{
    setState(() {
      _isLoading = true;
    });
    var result = await ModelService().doAuthRequest(
      GetStudentAbsenceRequest(scheduleID,widget.userId)
    );

    if (result is String) {
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
      return null;
    }
    setState(() {
      _isLoading = false;
    });
    return (result as GetStudentAbsenceResponse).absence > 0;
  }

  void changeAttendance(String scheduleID,bool attend) async{
    setState(() {
      _isLoading = true;
    });
    var result = await ModelService().doAuthRequest(
        SetStudentAbsenceRequest(widget.userId,scheduleID,attend)
    );
    if (result is String) {
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
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Attendance Changed"),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: ()=>ScaffoldMessenger.of(context).hideCurrentSnackBar(),
    ),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('Attendance'),
      ),
      body: Stack(children: [
        Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            child: Scrollbar(
              radius: Radius.circular(30),
              child: ListView.separated(
                  itemBuilder: (x, index) => ListTile(
                    title: Text(_data[index].date.split(" ")[0]),
                    subtitle: Text(_data[index].scheduleID),
                    isThreeLine: false,
                    trailing: IconButton(
                      icon: Icon(Icons.list),
                    onPressed: ()async{
                      bool result = await getSingleAttendance(_data[index].scheduleID);
                      if(result == null) return;
                      showDialog(context: context,builder: (x)=>AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: Text("Attendance Status"),
                        content: Text(result ? "Absent" : "Attend"),
                        actions: [
                          FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Text("Change"),
                            onPressed: (){
                              Navigator.of(context).pop();
                              changeAttendance(_data[index].scheduleID,result);
                            },
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Text("Ok"),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
                    },
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
      ]),
    );
  }
}
