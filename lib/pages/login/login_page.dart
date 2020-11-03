import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/login_model.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback _loginCallback;

  LoginPage(this._loginCallback);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  void _doLogin() async {
    var result = await ModelService().doRequest(
        LoginRequest(_usernameController.text, _passwordController.text));
    if (result is String) {
      showDialog(
        context: context,
        builder: (x)=>AlertDialog(
          title: Text('Error'),
          content: Text(result),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: ()=>Navigator.of(x).pop(),
            ),
          ],
        )
      );
    } else {
      var r = result as LoginResponse;
      await ModelService().setToken(r.token, r.refresh);
      widget._loginCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 32,
                ),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 52.0,
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Username',
                      hintText: 'xumarno'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Password',
                      hintText: '*******'),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'By logging in, you had agreed to terms and condition',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: _doLogin,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(11),
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 22),
                    ),
                    alignment: Alignment.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
