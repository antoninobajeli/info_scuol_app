import 'package:flutter/material.dart';



class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  static const String routeName = "/MainPage";

  final String title;

  @override
  _MainPageState createState() => new _MainPageState();
}

/// // 1. After the page has been created, register it with the app routes
/// routes: <String, WidgetBuilder>{
///   MainPage.routeName: (BuildContext context) => new MainPage(title: "MainPage"),
/// },
///
/// // 2. Then this could be used to navigate to the page.
/// Navigator.pushNamed(context, MainPage.routeName);
///

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onFloatingActionButtonPressed,
        tooltip: 'Add',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _onFloatingActionButtonPressed() {
  }
}