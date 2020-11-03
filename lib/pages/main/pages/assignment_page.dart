import 'package:flutter/material.dart';

class AssignmentPage extends StatefulWidget {
  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: ListView.separated(itemBuilder: (x,index)=>ListTile(
        title: Text('Creating web application'),
        subtitle: Text('Web Development'),
        trailing: Text('25/12/20'),
        isThreeLine: false,
        leading: CircleAvatar(
          backgroundColor: Colors.deepOrangeAccent.shade100,
          foregroundColor: Colors.white,
          child: Icon(index % 3 ==0 ? Icons.check : Icons.access_time_outlined),
        ),
      ), separatorBuilder: (ctx,index)=>Divider(), itemCount: 10),
    );
  }
}
