import 'package:flutter/material.dart';
import 'package:nusbi_flutter/pages/main/pages/admin/course/class/class_management.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/admin/course/get_teacher_model.dart';
import 'package:nusbi_flutter/model/models/admin/course/create_course_model.dart';
import 'package:nusbi_flutter/model/models/admin/course/get_course_model.dart';

class CourseManagement extends StatefulWidget {
  @override
  _CourseManagementState createState() => _CourseManagementState();
}

class _CourseManagementState extends State<CourseManagement> {
  var _isLoading = false;
  List<TeacherData> _teacherData = [];
  var _courseNameTextEditingController = TextEditingController();
  String _newLecturerID;
  var _courseScuTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCourses();
  }

  void _getCourses() async {
    setState(() {
      _isLoading = true;
    });
    var result = await ModelService().doAuthRequest(GetCourseRequest());
    setState(() {
      _isLoading = false;
    });
    if (result is String) {
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
                title: Text("Error"),
                content: Text(result),
              ));
      return;
    }
    _courseData = (result as GetCourseResponse).data;
    setState(() {});
  }

  List<GetCourseResponseData> _courseData = [];

  void _addNewCourses() async {
    Navigator.of(context).pop();
    int scu;
    try {
      scu = int.parse(_courseScuTextEditingController.text) ?? -1;
    } catch (_) {
      scu = -1;
    }
    if (_newLecturerID == "1" ||
        _newLecturerID == null ||
        _courseNameTextEditingController.text.length < 5 ||
        scu < 0 ||
        scu > 9) {
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
                title: Text("Error"),
                content: Text(
                    "Please make sure that the lecturer is not empty and the course name is at least 5 characters"),
              ));
      return;
    }
    setState(() => _isLoading = true);
    var result = await ModelService().doAuthRequest(CreateCourseRequest(
        name: _courseNameTextEditingController.text,
        scu: scu,
        teacherID: _newLecturerID));
    setState(() => _isLoading = false);
    if (result is String) {
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
                title: Text("Error"),
                content: Text(result),
              ));
      return;
    }
    _getCourses();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          'Course "${_courseNameTextEditingController.text}" is added sucesfully'),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    ));
    _courseScuTextEditingController.text = "";
    _newLecturerID = null;
    _courseNameTextEditingController.text = "";
  }

  void _addCourse() async {
    if (!await _getTeacherData()) return;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (x) => StatefulBuilder(
              builder: (x, ss) => AlertDialog(
                title: Text('Add new course'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _courseNameTextEditingController,
                      decoration: InputDecoration(labelText: 'Course name'),
                    ),
                    TextField(
                      controller: _courseScuTextEditingController,
                      decoration: InputDecoration(labelText: 'Course SCU'),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButton<String>(
                      hint: Text('Teacher\'s name'),
                      isExpanded: true,
                      value: _newLecturerID,
                      items: _teacherData.isNotEmpty
                          ? _teacherData
                              .map((e) => DropdownMenuItem(
                                    child: Text(e.name),
                                    value: e.iD,
                                  ))
                              .toList()
                          : [
                              DropdownMenuItem(
                                child: Text(''),
                                value: '1',
                              )
                            ],
                      onChanged: (value) {
                        ss(() => _newLecturerID = value);
                      },
                    )
                  ],
                ),
                actions: [
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(x).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('Add'),
                    onPressed: _addNewCourses,
                  )
                ],
              ),
            ));
  }

  Future<bool> _getTeacherData() async {
    setState(() => _isLoading = true);
    var result = await ModelService().doAuthRequest(GetTeacherRequest());
    setState(() => _isLoading = false);
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
      return false;
    }
    _teacherData = (result as GetTeacherResponse).data;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addCourse,
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 700),
              child: Scrollbar(
                radius: Radius.circular(30),
                child: ListView.separated(
                    itemBuilder: (x, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(_courseData[i].scu.toString()),
                            foregroundColor: Colors.white,
                          ),
                          title: Text(_courseData[i].name),
                          subtitle: Text(_courseData[i].teacherName),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (x) => ClassManagement(_courseData[i].name,_courseData[i].courseID))),
                        ),
                    separatorBuilder: (x, i) => Divider(
                          height: 0,
                        ),
                    itemCount: _courseData.length),
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
        ],
      ),
    );
  }
}
