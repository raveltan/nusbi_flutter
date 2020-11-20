import 'package:flutter/material.dart';
import 'package:nusbi_flutter/pages/main/pages/admin/course/schedule_management.dart';

class ClassManagement extends StatefulWidget {
  @override
  _ClassManagementState createState() => _ClassManagementState();
}

class _ClassManagementState extends State<ClassManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
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
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (x) => ScheduleManagement())),
                    ),
                separatorBuilder: (x, i) => Divider(height: 0,),
                itemCount: 10),
          ),
        ),
      ),
    );
  }
}
