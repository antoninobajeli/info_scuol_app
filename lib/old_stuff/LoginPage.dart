import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;


class LoginPage extends StatefulWidget{
  @override
  State createState()=>new _LoginPage();

}



class _LoginPage extends State<LoginPage> with SingleTickerProviderStateMixin {

  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  Image _bkgImg;
  FlutterLogo _fl;
  InputDecorationTheme _inpDecTheme;
  TextStyle _labelTextStyle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _iconAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 500),
    );
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.bounceOut
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();


    _bkgImg = new Image(
      image: new AssetImage("assets/isa_logo.png"),
      fit: BoxFit.fill,
      color: Colors.white70,
      colorBlendMode: BlendMode.dstOut,
    );

    _labelTextStyle = new TextStyle(color: Colors.teal, fontSize: 20.0);
    _inpDecTheme = new InputDecorationTheme(labelStyle: _labelTextStyle);
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _fl = new FlutterLogo(size: _iconAnimation.value * 80.0);
    return new Scaffold(
      backgroundColor: Colors.white,

      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _bkgImg,
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _fl,
              new Form(
                  child: new Theme(
                    data: new ThemeData(
                        brightness: Brightness.dark,
                        primarySwatch: Colors.teal,
                        primaryColor: Colors.teal,
                        inputDecorationTheme: _inpDecTheme

                    ),
                    child: new Container(
                      padding: const EdgeInsets.all(20.0),

                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new TextFormField(
                              decoration: new InputDecoration(
                                  labelText: "username"),
                              keyboardType: TextInputType.emailAddress
                          ),


                          new TextFormField(
                            decoration: new InputDecoration(
                                labelText: "password"),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                          new Padding(padding: const EdgeInsets.only(top:20.0)),
                          new MaterialButton(
                            color: Colors.teal,
                            textColor: Colors.teal,
                            child: new Icon(Icons.arrow_forward),
                            onPressed: () => {},
                            splashColor: Colors.redAccent,
                          ),

                        ],
                      ),
                    ),
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}

  /*
          new Center(
            child: new ClipRect(
              child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: new Container(
                  width: 300.0,
                  height: 400.0,
                  decoration: new BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.5)
                  ),
                  child: new Center(
                    child: new Text(
                        '',
                        style: Theme.of(context).textTheme.display3
                    ),
                  ),
                ),
              ),
            ),
          ),
*/
