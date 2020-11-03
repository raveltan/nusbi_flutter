import 'package:flutter/material.dart';
import 'package:nusbi_flutter/pages/main/pages/admin/user/user_new.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('User management'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showDialog(
                context: context,
                builder: (x) => SimpleDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      title: Text('Select type'),
                      children: [
                        ListTile(
                          title: Text('Student'),
                          contentPadding: EdgeInsets.symmetric(horizontal: 24),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (x) => NewUserPage('student')));
                          },
                        ),
                        ListTile(
                          title: Text('Teacher'),
                          contentPadding: EdgeInsets.symmetric(horizontal: 24),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (x) => NewUserPage('teacher')));
                          },
                        ),
                        ListTile(
                          title: Text('Admin'),
                          contentPadding: EdgeInsets.symmetric(horizontal: 24),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (x) => NewUserPage('admin')));
                          },
                        ),
                      ],
                    )),
          )
        ],
      ),
      body: ListView.separated(
          itemBuilder: (x, i) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.supervisor_account_outlined),
                ),
                title: Text('Ravel Tan'),
                subtitle: Text('ADMIN'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {},
              ),
          separatorBuilder: (x, i) => Divider(),
          itemCount: 10),
    );
  }
}
