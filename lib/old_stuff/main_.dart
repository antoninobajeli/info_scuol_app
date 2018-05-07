import 'package:flutter/material.dart';
import 'package:info_scuol_app/old_stuff/Login5.dart';
import 'package:info_scuol_app/model/IsaTutenze.dart';


/*
per la denerazione dei modelli
 ../../Documents/FlutterSDK/flutter/bin/flutter packages pub run build_runner watch
 */

void main() => runApp(new AppComponent());


abstract class  CredentialProvider {
  void setCredential(IsaTutenze c);
}



class AppComponent extends StatefulWidget {
  _AppComponentState createState() => new _AppComponentState();
}

class _AppComponentState extends State<AppComponent> implements CredentialProvider {

  IsaTutenze credential;

  @override
  Widget build(BuildContext context) {
    if (credential == null) {
      return new MaterialApp(
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => new Login5( title: "", onSubmit: () { setCredential(ff)}
          ),
        },
      );
    } else {
      return new MaterialApp(
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => new Desktop(credential),

        },
      );
    }
  }


  @override
  void setCredential(IsaTutenze s) {
    setState(() {
      credential = s;
    });
  }

}

