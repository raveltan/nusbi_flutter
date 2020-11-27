import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
  List _currentEvent = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('Schedule'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 400,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TableCalendar(
                calendarController: _calendarController,
                calendarStyle: CalendarStyle(
                  markersColor: Colors.blue.shade700,
                  selectedColor: Colors.deepOrange.shade300,
                ),
                events: {
                  DateTime.now().add(Duration(days: 2)): ['Mid Exam', 'Homework']
                },
                onDaySelected: (_, event, _a) {
                  setState(() {
                    _currentEvent = event;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Event',style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),),
              ),
              Expanded(child: Scrollbar(
                radius: Radius.circular(30),
                child: ListView.separated(
                    itemBuilder: (c,i)=>ListTile(
                      title: Text(_currentEvent[i]),
                      subtitle: Text('Event'),
                    ),
                    separatorBuilder: (c,i)=>Divider(),
                    itemCount: _currentEvent.length),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
