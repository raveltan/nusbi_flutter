import 'package:flutter/material.dart';

class MajorManagement extends StatefulWidget {
  @override
  _MajorManagementState createState() => _MajorManagementState();
}

class _MajorManagementState extends State<MajorManagement> {
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
            title: Text('Computer Science'),
            trailing: IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: (){},
            ),
          ),
          separatorBuilder: (x, i) => Divider(),
          itemCount: 10),
    );
  }
}
