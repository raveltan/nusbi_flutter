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
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 700),
          child: Scrollbar(
            radius: Radius.circular(30),
            child: ListView.separated(
                itemBuilder: (x, i) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        child: Icon(Icons.supervisor_account_outlined),
                      ),
                      title: Text('Ravel Tan'),
                      subtitle: Text('ADMIN'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () => showDialog(
                            context: context,
                            builder: (x) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  title: Text("Delete user"),
                                  actions: [
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Text("Yes"),
                                      onPressed: () {},
                                    ),
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Text("No"),
                                      onPressed: () => Navigator.of(x).pop(),
                                    )
                                  ],
                                )),
                      ),
                      onTap: () {},
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
