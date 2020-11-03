import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('Courses'),
      ),body: ListView.separated(itemBuilder: (x,index)=>ListTile(
      title: Text('Web development'),
      subtitle: Text('Mr. White'),
      isThreeLine: false,
      leading: CircleAvatar(
        backgroundColor: Colors.deepOrangeAccent.shade100,
        foregroundColor: Colors.white,
        child: Text((index % 5).toString()),
      ),
    ), separatorBuilder: (ctx,index)=>Divider(), itemCount: 10),
    );
  }
}
