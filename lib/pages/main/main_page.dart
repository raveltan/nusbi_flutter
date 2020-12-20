import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/pages/main/pages/admin/course/course_management.dart';
import 'package:nusbi_flutter/pages/main/pages/admin/major/major_management.dart';
import 'package:nusbi_flutter/pages/main/pages/admin/user/user_management.dart';
import 'package:nusbi_flutter/pages/main/pages/student/attendance_page.dart';
import 'package:nusbi_flutter/pages/main/pages/student/courses_page.dart';
import 'package:nusbi_flutter/pages/main/pages/student/profile_page.dart';
import 'package:nusbi_flutter/pages/main/pages/student/schedule_page.dart';
import 'package:nusbi_flutter/pages/main/pages/teacher/teacher_profile_page.dart';

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

  var _userRole = '';
  var _username = '';

  @override
  void initState() {
    super.initState();
    _userRole = ModelService().userRole;
    _username = ModelService().username;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _studentMenuList = [
      ListTile(
          title: Text('Schedule'),
          leading: Icon(Icons.calendar_today),
          onTap: () => _drawerNavigation(SchedulePage())),
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
    ];
    List<Widget> _adminMenuList = [
      ListTile(
          title: Text('User management'),
          leading: Icon(Icons.account_circle_outlined),
          onTap: () => _drawerNavigation(UserManagementPage())),
      ListTile(
          title: Text('Course management'),
          leading: Icon(Icons.book),
          onTap: () => _drawerNavigation(CourseManagement())),
      ListTile(
          title: Text('Major management'),
          leading: Icon(Icons.account_tree_outlined),
          onTap: () => _drawerNavigation(MajorManagement())),
    ];

    List<Widget> _teacherMenuList = [
      ListTile(
        title: Text('Schedule'),
        leading: Icon(Icons.calendar_today),
        onTap: () {},
      ),
      ListTile(
        title: Text('Courses'),
        leading: Icon(Icons.book),
        onTap: () {},
      ),
      Divider(
        thickness: 1.5,
      ),
      ListTile(
        leading: Icon(Icons.account_circle),
        title: Text('Profile'),
        onTap: () => _drawerNavigation(TeacherProfilePage()),
      ),
    ];
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
                    _userRole == 'a'
                        ? 'ADMIN'
                        : _userRole == 's'
                            ? 'STUDENT'
                            : 'TEACHER',
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  )),
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
              ),
            ),
            ...(_userRole == 's'
                ? _studentMenuList
                : _userRole == 'a'
                    ? _adminMenuList
                    : _teacherMenuList),
            Divider(
              thickness: 1.5,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
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
                  child: Icon(
                    Icons.supervisor_account_outlined,
                    size: 32,
                  ),
                  radius: 32,
                  backgroundColor: Colors.deepOrange.shade50,
                  foregroundColor: Colors.deepOrange,
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    Text('$_username',
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))),
                      context: context,
                      builder: (ctx) => Center(
                            child: Container(
                              constraints:
                                  BoxConstraints(maxWidth: 500, maxHeight: 500),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 48),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BarcodeWidget(
                                    barcode: Barcode.qrCode(),
                                    // TODO: change with dynamic data
                                    data: '$_username',
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(
                                    '@$_username',
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
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

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.book,
                  size: 52,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Access the menu \nby tapping the hamburger button',
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
