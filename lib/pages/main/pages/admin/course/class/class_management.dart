import 'package:flutter/material.dart';
import 'package:nusbi_flutter/pages/main/pages/admin/course/schedule/schedule_management.dart';

class ClassManagement extends StatefulWidget {
  final String title;
  final String id;

  ClassManagement(this.title, this.id);

  @override
  _ClassManagementState createState() => _ClassManagementState();
}

class _ClassManagementState extends State<ClassManagement> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {}

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
                              //controller: _courseNameTextEditingController,
                              decoration:
                                  InputDecoration(labelText: 'Class Name'),
                            ),
                            TextField(
                              //controller: _courseScuTextEditingController,
                              decoration: InputDecoration(labelText: 'Batch'),
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
                            onPressed: _addNewCourses,
                          )
                        ],
                      ));
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 700),
          child: Scrollbar(
            radius: Radius.circular(30),
            child: ListView.separated(
                itemBuilder: (x, i) => ListTile(
                      title: Text('L3AC'),
                      subtitle: Text('Batch 2020'),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (x) => ScheduleManagement(
                              widget.title + ' - ' + 'L3AC', 'dsfasfs'))),
                    ),
                separatorBuilder: (x, i) => Divider(
                      height: 0,
                    ),
                itemCount: 10),
          ),
        ),
      ),
    );
  }

  void _addNewCourses() {}
}
