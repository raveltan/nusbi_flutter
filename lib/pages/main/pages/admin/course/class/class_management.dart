import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/admin/course/class/create_class_model.dart';
import 'package:nusbi_flutter/model/models/admin/course/class/get_class_model.dart';
import 'package:nusbi_flutter/pages/main/pages/admin/course/schedule/schedule_management.dart';

class ClassManagement extends StatefulWidget {
  final String title;
  final String id;

  ClassManagement(this.title, this.id);

  @override
  _ClassManagementState createState() => _ClassManagementState();
}

class _ClassManagementState extends State<ClassManagement> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<ClassData> _data = [];

  void getData() async {
    toggleLoading(true);
    var result = await ModelService().doAuthRequest(GetClassRequest(widget.id));
    toggleLoading(false);
    if (result is String) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
                title: Text("Error"),
                content: Text(result),
              ));
      return;
    }
    _data = (result as GetClassResponse).data;
    setState(() {});
  }

  void toggleLoading(bool status) {
    setState(() {
      _isLoading = status;
    });
  }

  var classNameTextEditingController = TextEditingController();
  var batchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (x) => AlertDialog(
                        title: Text('Add Class'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: classNameTextEditingController,
                              decoration:
                                  InputDecoration(labelText: 'Class Name'),
                            ),
                            TextField(
                              decoration: InputDecoration(labelText: 'Batch'),
                              controller: batchTextEditingController,
                              keyboardType: TextInputType.number,
                            ),
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
                            onPressed: _addNewClass,
                          )
                        ],
                      ));
            },
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
                        title: Text(_data[i].className),
                        subtitle: Text(_data[i].batch.toString()),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (x) => ScheduleManagement(
                                    widget.title + ' - ' + _data[i].className, _data[i].classID))),
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

  void _addNewClass() async {
    Navigator.of(context).pop();
    toggleLoading(true);
    var result = await ModelService().doAuthRequest(CreateClassRequest(
        classNameTextEditingController.text,
        widget.id,
        batchTextEditingController.text));
    toggleLoading(false);
    if (result is String) {
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
                title: Text("Error"),
                content: Text(result),
              ));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          'Class "${classNameTextEditingController.text}" is added successfully'),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    ));
    classNameTextEditingController.text = '';
    batchTextEditingController.text = '';
    getData();
  }
}
