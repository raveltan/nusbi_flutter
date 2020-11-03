import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/login_model.dart';
import 'package:nusbi_flutter/pages/main/pages/assignment_page.dart';
import 'package:nusbi_flutter/pages/main/pages/attendance_page.dart';
import 'package:nusbi_flutter/pages/main/pages/courses_page.dart';
import 'package:nusbi_flutter/pages/main/pages/profile_page.dart';
import 'package:nusbi_flutter/pages/main/pages/schedule_page.dart';

class MainPage extends StatefulWidget {
  final VoidCallback _signOutCallback;

  MainPage(this._signOutCallback);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void _drawerNavigation(Widget destination) {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => destination));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'STUDENT',
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  )),
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
              ),
            ),
            ListTile(
                title: Text('Schedule'),
                leading: Icon(Icons.calendar_today),
                onTap: () => _drawerNavigation(SchedulePage())),
            ListTile(
                title: Text('Assignment'),
                leading: Icon(Icons.add_box_rounded),
                onTap: () => _drawerNavigation(AssignmentPage())),
            ListTile(
              title: Text('Courses'),
              leading: Icon(Icons.book),
              onTap: () => _drawerNavigation(CoursesPage()),
            ),
            ListTile(
              title: Text('Attendance'),
              leading: Icon(Icons.account_tree_outlined),
              onTap: () => _drawerNavigation(AttendancePage()),
            ),
            Divider(
              thickness: 1.5,
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () => _drawerNavigation(ProfilePage()),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async{
                await ModelService().logout();
                widget._signOutCallback();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Nosebee'),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // TODO: refactor to it's own componnet
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
              decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(
                      'XY',
                      style: TextStyle(fontSize: 24),
                    ),
                    radius: 32,
                    backgroundColor: Colors.deepOrange.shade100,
                    foregroundColor: Colors.black,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      Text('Xumarno Ya',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  InkWell(
                    onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (ctx) => Container(
                              padding: EdgeInsets.all(64),
                              alignment: Alignment.center,
                              child: BarcodeWidget(
                                barcode: Barcode.qrCode(),
                                // TODO: change with dynamic data
                                data: 'XUMARNO YA',
                              ),
                            )),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.qr_code_scanner_outlined),
                    ),
                  )
                ],
              ),
            ),
            /*
              Content of the application
             */
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Card(
                  color: Colors.deepOrangeAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Grade Point Average',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '3.88',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Courses Enrolled',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '50/210',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Current Courses',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '5',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
