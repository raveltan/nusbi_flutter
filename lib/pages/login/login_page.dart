import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/auth/login_model.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback _loginCallback;

  LoginPage(this._loginCallback);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _obscure = true;
  var _isLoading = false;

  void _doLogin() async {
    setState(() {
      _isLoading = true;
    });
    var result = await ModelService().doRequest(
        LoginRequest(_usernameController.text, _passwordController.text));
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
    if (result is String) {
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
                title: Text('Error'),
                content: Text(result),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                actions: [
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(x).pop(),
                  ),
                ],
              ));
    } else {
      var r = result as LoginResponse;
      await ModelService().setToken(
          r.token, r.refresh, r.role, _usernameController.text.toLowerCase());
      widget._loginCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
            color: Colors.deepOrangeAccent,
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              constraints: BoxConstraints(maxWidth: 400),
              child: Scrollbar(
                radius: Radius.circular(30),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 32.0,
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
                          onSubmitted: (_) => _doLogin(),
                          controller: _passwordController,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: _obscure
                                    ? Icon(Icons.visibility_outlined)
                                    : Icon(Icons.visibility_off_outlined),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Password',
                              hintText: '******'),
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
                          color: Colors.deepOrange,
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
      ),
    );
  }
}
