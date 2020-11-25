import 'package:flutter/material.dart';
import 'package:nusbi_flutter/pages/main/pages/admin/course/class_management.dart';

class CourseManagement extends StatefulWidget {
  @override
  _CourseManagementState createState() => _CourseManagementState();
}

class _CourseManagementState extends State<CourseManagement> {
  var _isLoading = false;
  void _addCourse(){
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
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
                          title: Text('Introduction to programming'),
                          subtitle: Text('6 SCU'),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (x) => ClassManagement())),
                        ),
                    separatorBuilder: (x, i) => Divider(
                          height: 0,
                        ),
                    itemCount: 10),
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
}
