import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/teacher/get_teacher_class_student_model.dart';
import 'package:nusbi_flutter/model/models/teacher/set_student_final_score_model.dart';
import 'package:nusbi_flutter/model/models/teacher/set_student_mid_score_model.dart';
import 'package:nusbi_flutter/pages/main/pages/teacher/class/teacher_class_attendance.dart';

class TeacherClassStudentPage extends StatefulWidget {
  String ID;
  String className;
  String classID;
  TeacherClassStudentPage(this.ID, this.className,this.classID);

  @override
  _TeacherClassStudentPage createState() => _TeacherClassStudentPage();
}

class _TeacherClassStudentPage extends State<TeacherClassStudentPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<ClassStudentData> _data = [];

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    var result =
        await ModelService().doAuthRequest(GetClassStudentRequest(widget.ID));

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
    _data = (result as GetClassStudentResponse).classStudentData ?? [];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(widget.className),
      ),
      body: Stack(children: [
        Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            child: Scrollbar(
              radius: Radius.circular(30),
              child: ListView.separated(
                  itemBuilder: (x, index) {
                    var midScore = _data[index].midScore;
                    var finalScore = _data[index].finalScore;
                    return ListTile(
                      dense: false,
                      contentPadding: EdgeInsets.all(8),
                      title: Text(_data[index].name),
                      subtitle: Row(
                        children: [
                          Chip(
                            label:
                                Text('Mid: ${midScore > 0 ? midScore : '-'}'),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Chip(
                            label: Text(
                                'Final: ${finalScore > 0 ? finalScore : '-'}'),
                          )
                        ],
                      ),
                      isThreeLine: false,
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _studentAction(_data[index].studentID),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepOrangeAccent.shade100,
                        foregroundColor: Colors.white,
                        child: Icon(Icons.account_circle),
                      ),
                    );
                  },
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

  void _studentAction(String studentID) => showDialog(
        context: (context),
        builder: (x) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Action"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Attendance'),
                onTap: () {
                  Navigator.of(context).pop();
                  return Navigator.of(context).push(MaterialPageRoute(
                      builder: (x) =>
                          TeacherClassAttendance(widget.classID, studentID)));
                },
              ),
              ListTile(
                title: Text('Set Mid Score'),
                onTap: () => _setMidScore(studentID),
              ),
              ListTile(
                title: Text('Set Final Score'),
                onTap: () => _setFinalScore(studentID),
              ),
            ],
          ),
        ),
      );

  void _setMidScore(String studentID) async {
    Navigator.of(context).pop();
    var midScoreTextController = TextEditingController();
    await showDialog(
        context: context,
        builder: (x) => AlertDialog(
              title: Text("Set Mid Score"),
              content: TextField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: midScoreTextController,
                onSubmitted: (x) => _doSetMidScore(x, true, studentID),
                decoration: InputDecoration(labelText: 'Mid Score'),
              ),
              actions: [
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text('Set'),
                  onPressed: () => _doSetMidScore(
                      midScoreTextController.text, true, studentID),
                ),
              ],
            ));
  }

  void _setFinalScore(String studentID) async {
    Navigator.of(context).pop();
    var midScoreTextController = TextEditingController();
    await showDialog(
        context: context,
        builder: (x) => AlertDialog(
              title: Text("Set Final Score"),
              content: TextField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: midScoreTextController,
                onSubmitted: (x) => _doSetMidScore(x, false, studentID),
                decoration: InputDecoration(labelText: 'Final Score'),
              ),
              actions: [
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text('Set'),
                  onPressed: () => _doSetMidScore(
                      midScoreTextController.text, false, studentID),
                ),
              ],
            ));
  }

  void _doSetMidScore(String value, bool mid, String studentID) async {
    Navigator.of(context).pop();
    var valueAsInt = int.tryParse(value) ?? -1;
    if (valueAsInt < 0 || valueAsInt > 100) {
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
                title: Text("Error"),
                content: Text("Score should be 0 .. 100"),
              ));
    }
    var result;
    setState(() {
      _isLoading = true;
    });
    if (mid) {
      result = await ModelService().doAuthRequest(
          SetStudentMidScoreRequest(studentID, widget.ID, valueAsInt));
    } else {
      result = await ModelService().doAuthRequest(
          SetStudentFinalScoreRequest(studentID, widget.ID, valueAsInt));
    }
    setState(() {
      _isLoading = false;
    });
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
    getData();
  }
}
