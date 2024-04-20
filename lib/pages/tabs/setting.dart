import 'package:flutter/material.dart';

void main() {
  runApp(const SettingPage());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Setting",
              style: TextStyle(color: Color.fromRGBO(255, 213, 74, 1)),
            ),
            backgroundColor: const Color.fromRGBO(100, 0, 200, 0.8),
          ),
          body: Container(
              child: Center(
                  child: ListView(
            scrollDirection: Axis.vertical,
            children: const <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                title: Text("Account"),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                title: Text("Language"),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                title: Text("Notification"),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                title: Text("Support"),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                title: Text("Privacy"),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                title: Text("Logout"),
              ),
              Divider(),
            ],
          )))),
    );
  }
}
