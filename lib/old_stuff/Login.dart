import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';



class Login extends StatelessWidget{

  const Login({
    Key key,
    @required this.onSubmit,
   }) : super (key:key);

  final VoidCallback onSubmit;
  static final TextEditingController _user=new TextEditingController();
  static final TextEditingController _pass=new TextEditingController();

  String get username => _user.text;
  String get password => _pass.text;





  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Image _bkgImg = new Image(
      image: new AssetImage("assets/isa_logo.png"),
      fit: BoxFit.none,
      color: Colors.white70,
      colorBlendMode: BlendMode.dstOut,
    );


    TextStyle _labelTextStyle = new TextStyle(color: Colors.teal, fontSize: 20.0);
    InputDecorationTheme _inpDecTheme = new InputDecorationTheme(labelStyle: _labelTextStyle);

    return
      new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _bkgImg,
          new Form(
              child: new Theme(
                data: new ThemeData(
                    brightness: Brightness.light,
                    primarySwatch: Colors.teal,
                    primaryColor: Colors.teal,

                    inputDecorationTheme: _inpDecTheme
            ),
            child: new Container(
              padding: const EdgeInsets.all(20.0),



              child:  new Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: <Widget>[
                          new TextFormField(
                            controller: _user,
                            decoration: new InputDecoration(labelText: "Email"),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          new TextFormField(
                            controller: _pass,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(labelText: "Password"),
                            obscureText: true,),
                          new Padding(padding: const EdgeInsets.only(top:20.0)),
                          new MaterialButton(
                            color: Colors.teal,
                            textColor: Colors.white70,
                            child: new Icon(Icons.arrow_forward),
                            onPressed: onSubmit,
                            splashColor: Colors.redAccent,
                          ),
                      ]

                    ),

    ),
              ),)


      ]);
  }



}