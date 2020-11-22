import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/admin/user/get_user_model.dart';
import 'package:nusbi_flutter/pages/main/pages/admin/user/user_new.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  List<UserResponseData> _users = [];

  Future<void> getUsers() async {
    setState(() {
      _isLoading = true;
    });
    var result = await ModelService().doAuthRequest(GetUserRequest());
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
    _users = (result as GetUserResponse).data;
    setState(() {
      _isLoading = false;
    });
  }

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
                                builder: (x) =>
                                    NewUserPage('student', getUsers)));
                          },
                        ),
                        ListTile(
                          title: Text('Teacher'),
                          contentPadding: EdgeInsets.symmetric(horizontal: 24),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (x) =>
                                    NewUserPage('teacher', getUsers)));
                          },
                        ),
                        ListTile(
                          title: Text('Admin'),
                          contentPadding: EdgeInsets.symmetric(horizontal: 24),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (x) =>
                                    NewUserPage('admin', getUsers)));
                          },
                        ),
                      ],
                    )),
          )
        ],
      ),
      body: Stack(children: [
        Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            child: Scrollbar(
              radius: Radius.circular(30),
              child: ListView.separated(
                  itemBuilder: (x, i) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          child: Icon(_users[i].role == 'a'
                              ? Icons.verified_user
                              : _users[i].role == 's'
                                  ? Icons.account_circle_outlined
                                  : Icons.book_rounded),
                        ),
                        title: Text('${_users[i].username}'),
                        subtitle: Text(
                            '${_users[i].role == 'a' ? "Admin" : _users[i].role == 's' ? "Student" : "Teacher"}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () => showDialog(
                              context: context,
                              builder: (x) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                  itemCount: _users.length),
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
      ]),
    );
  }
}
