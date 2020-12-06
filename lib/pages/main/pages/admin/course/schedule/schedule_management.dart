import 'package:flutter/material.dart';

class ScheduleManagement extends StatefulWidget {
  String title;
  String id;
  ScheduleManagement(this.title,this.id);
  @override
  _ScheduleManagementState createState() => _ScheduleManagementState();
}

class _ScheduleManagementState extends State<ScheduleManagement> {
  DateTime _newScheduleData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              _newScheduleData = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  initialDatePickerMode: DatePickerMode.day,
                  firstDate: DateTime(2015),
                  lastDate: DateTime(2101));
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
                      trailing: IconButton(
                        icon: Icon(Icons.delete_sharp),
                        onPressed: () {},
                      ),
                      title: Text(DateTime.now().toIso8601String()),
                      subtitle: Text('COMP6953'),
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
}
