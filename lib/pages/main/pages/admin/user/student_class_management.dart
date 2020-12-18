import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/admin/course/enroll_student_model.dart';
import 'package:nusbi_flutter/model/models/admin/course/get_class_course.dart';
import 'package:nusbi_flutter/model/models/admin/course/get_enroll_model.dart';
import 'package:nusbi_flutter/model/models/admin/major/get_major_model.dart';

class StudentClassManagement extends StatefulWidget {
  String username;

  StudentClassManagement(this.username);

  @override
  _StudentClassManagement createState() => _StudentClassManagement();
}

class _StudentClassManagement extends State<StudentClassManagement> {
  List<EnrollResponse> _data = [];
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void addClass() async {
    setState(() => this._isLoading = true);
    var result = await ModelService()
        .doAuthRequest(GetClassCourseRequest(widget.username));
    setState(() => this._isLoading = false);
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
    var _res = result as GetClassCourseResponse;

    var _resId = await Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (x) => Scaffold(
              appBar: AppBar(
                title: Text('Select Class'),
              ),
              body: ListView.builder(
                  itemCount: _res.data.length,
                  itemBuilder: (x, i) => ListTile(
                        title: Text(_res.data[i].courseName),
                        subtitle: Text(_res.data[i].className),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.of(x).pop(_res.data[i].classID);
                          },
                          icon: Icon(Icons.add),
                        ),
                      )),
            )));
    if (_resId == null) return;
    var _err = await ModelService()
        .doAuthRequest(EnrollStudentRequest(_resId, widget.username));
    if (_err is String) {
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
                title: Text('Error'),
                content: Text(_err),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Class is added successfully enrolled'),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    ));
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    var result = await ModelService().doAuthRequest(GetEnrolledRequest(widget.username));

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
    _data = (result as GetEnrolledResponse).data ?? [];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username} - Class'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addClass,
          )
        ],
      ),
      body: Stack(children: [
        Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            child: Scrollbar(
              radius: Radius.circular(30),
              child: ListView.separated(
                  itemBuilder: (x, i) => ListTile(
                        title: Text(_data[i].courseName),
                        subtitle: Text(_data[i].className),
                      ),
                  separatorBuilder: (x, i) => Divider(
                        height: 0,
                      ),
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
