import 'package:flutter/material.dart';
import 'package:nusbi_flutter/pages/main/pages/admin/course/class_management.dart';

class CourseManagement extends StatefulWidget {
  @override
  _CourseManagementState createState() => _CourseManagementState();
}

class _CourseManagementState extends State<CourseManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){},
          )
        ],
      ),
      body: ListView.separated(
          itemBuilder: (x, i) => ListTile(
                title: Text('Introduction to programming'),
                subtitle: Text('6 SCU'),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (x) => ClassManagement())),
              ),
          separatorBuilder: (x, i) => Divider(),
          itemCount: 10),
    );
  }
}
