import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/admin/course/schedule/create_schedule_model.dart';
import 'package:nusbi_flutter/model/models/admin/course/schedule/delete_schedule_model.dart';
import 'package:nusbi_flutter/model/models/admin/course/schedule/get_schedule_model.dart';

class ScheduleManagement extends StatefulWidget {
  String title;
  String id;

  ScheduleManagement(this.title, this.id);

  @override
  _ScheduleManagementState createState() => _ScheduleManagementState();
}

class _ScheduleManagementState extends State<ScheduleManagement> {
  List<ScheduleData> _data = [];

  void toggleLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }



  Future<void> getData() async {
    toggleLoading(true);
    var result =
        await ModelService().doAuthRequest(GetScheduleRequest(widget.id));
    toggleLoading(false);
    if (result is String) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
                title: Text("Error"),
                content: Text(result),
              ));
      return;
    }
    _data = (result as GetScheduleResponse).data;
    setState(() {});
  }

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

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
              var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  initialDatePickerMode: DatePickerMode.day,
                  firstDate: DateTime(2015),
                  lastDate: DateTime(2101));
              if(date == null) {
                return;
              }
              var dob = "${date.year}-${date.month}-${date.day}";
              toggleLoading(true);
              var result = await ModelService()
                  .doAuthRequest(CreateScheduleRequest(dob, widget.id));
              toggleLoading(false);
              if (result is String) {
                showDialog(
                    context: context,
                    builder: (x) => AlertDialog(
                          title: Text("Error"),
                          content: Text(result),
                        ));
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('New Schedule is added successfully'),
                action: SnackBarAction(
                  label: 'Ok',
                  onPressed: () =>
                      ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                ),
              ));
              getData();
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 700),
              child: Scrollbar(
                radius: Radius.circular(30),
                child: ListView.separated(
                    itemBuilder: (x, i) => ListTile(
                          trailing: IconButton(
                            icon: Icon(Icons.delete_sharp),
                            onPressed: ()=>deleteSchedule(_data[i].scheduleID),
                          ),
                          title: Text(_data[i].date.split(" ")[0]),
                        ),
                    separatorBuilder: (x, i) => Divider(
                          height: 0,
                        ),
                    itemCount: _data.length),
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
        ],
      ),
    );
  }

  void deleteSchedule(String id) async {
    toggleLoading(true);
    var result = await ModelService()
        .doAuthRequest(DeleteScheduleRequest(id));
    toggleLoading(false);
    if (result is String) {
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
            title: Text("Error"),
            content: Text(result),
          ));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Schedule deleted successfully'),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () =>
            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    ));
    getData();
  }
}
