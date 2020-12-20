import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/student/get_student_schedule_model.dart';
import 'package:nusbi_flutter/model/models/teacher/get_teacher_schedule_model.dart';
import 'package:table_calendar/table_calendar.dart';

class TeacherSchedulePage extends StatefulWidget {
  @override
  _TeacherSchedulePageState createState() => _TeacherSchedulePageState();
}


class _TeacherSchedulePageState extends State<TeacherSchedulePage> {
  CalendarController _calendarController;
  var _isLoading =false;


  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    getData();
  }


  Map<DateTime,List<String>> _data = {};

  void getData() async{
    setState(() {
      _isLoading = true;
    });
    var result = await ModelService().doAuthRequest(GetTeacherScheduleRequest());

    if (result is String) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
            title: Text('Error'),
            content: Text(result),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () => Navigator.of(x).pop(),
              )
            ],
          ));
      return;
    }
    for(var x in (result as GetTeacherScheduleResponse).teacherScheduleResult ?? []){
      if(_data[DateTime.parse(x.date)] == null){
        _data[DateTime.parse(x.date)] = ['${x.course} - ${x.className}'];
      }else{
        _data[DateTime.parse(x.date)].add('${x.course} - ${x.className}');
      }
    }
    setState(() {
      _isLoading = false;
    });
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
      body: Stack(
          children: [Center(
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
                    events: _data,
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
            _isLoading
                ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.4),
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Please wait',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
              ),
            )
                : Container(),
          ]
      ),
    );
  }
}
