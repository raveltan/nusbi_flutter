import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('Attendance'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 700),
          child: Scrollbar(
            radius: Radius.circular(30),
            child: ListView.separated(
                itemBuilder: (x, index) => ListTile(
                      title: Text('Creating web application'),
                      subtitle: Text('Web Development'),
                      trailing: Text('2/$index Absents'),
                      isThreeLine: false,
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepOrangeAccent.shade100,
                        foregroundColor: Colors.white,
                        child: Icon(
                            index % 3 == 0 ? Icons.check : Icons.dangerous),
                      ),
                    ),
                separatorBuilder: (ctx, index) => Divider(),
                itemCount: 5),
          ),
        ),
      ),
    );
  }
}
