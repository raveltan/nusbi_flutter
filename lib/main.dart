import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/pages/login/login_page.dart';
import 'package:nusbi_flutter/pages/main/main_page.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bootstrap(),
      theme: ThemeData.light().copyWith(
          primaryColor: Colors.deepOrangeAccent,
          accentColor: Colors.deepOrangeAccent.shade200),
    ));

class Bootstrap extends StatefulWidget {
  @override
  _BootstrapState createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  var _login = false;

  void refreshLogin() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ModelService().getToken(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.done && !snap.hasError) {
          _login = snap.data as bool;
          return _login ? MainPage(refreshLogin) : LoginPage(refreshLogin);
        }
        return Scaffold(
          body: Container(
            color: Colors.deepOrangeAccent,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Nosebee',
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Faster Education',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
