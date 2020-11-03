import 'package:flutter/material.dart';

class ScheduleManagement extends StatefulWidget {
  @override
  _ScheduleManagementState createState() => _ScheduleManagementState();
}

class _ScheduleManagementState extends State<ScheduleManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
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
            title: Text(DateTime.now().toLocal().toString()),
            subtitle: Text('COMP6953'),
            onTap: ()=>null,
          ),
          separatorBuilder: (x, i) => Divider(),
          itemCount: 10),
    );
  }
}
