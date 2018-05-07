
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:info_scuol_app/util/Network.dart';
import 'package:info_scuol_app/model/RequestEnvelop.dart';
import 'package:info_scuol_app/model/ResponseEnvelop.dart';
import 'package:info_scuol_app/model/IsaTutenze.dart';

import 'package:flutter/services.dart';


class Registration extends StatefulWidget{
  const Registration ({
    Key key,
    this.verifyToken,
    @required this.onChangedUser,
  }) : super(key: key);

  final String verifyToken;
  final ValueChanged<ResponseEnvelop> onChangedUser;

  @override
  _RegistrationState createState() => new _RegistrationState();
}



class _RegistrationState extends State<Registration> {
  _RegistrationState({
    GlobalKey pscaffoldKey,
  });

  IsaTutenze getIsaTutenze(){
    return _user;
  }



  final GlobalKey pscaffoldKey;
  final VoidCallback onLoggedInState;


  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey;

  final VoidCallback onSubmit;
  BuildContext lcontext;

  // controllers for form text controllers
  //final TextEditingController _emailCtrl1 = new TextEditingController();
  //final TextEditingController _emailCtrl2 = new TextEditingController();
  String _email1,_email2;
  //final TextEditingController _psswdCtrl1 = new TextEditingController();
  //final TextEditingController _psswdCtrl2 = new TextEditingController();
  String _password1,_password2;

  bool sending = false;

  IsaTutenze _user;
  String _verifyToken;
  final MethodChannel channel = const MethodChannel("deeplink.channel/registration");


  @override
  void initState() {

    super.initState();
    _verifyToken=widget.verifyToken;
    debugPrint("Registration initState with _verifyToken:$_verifyToken");
    channel.setMethodCallHandler((MethodCall call) async {
      debugPrint("setMethodCallHandler call = $call");

      if (call.method == "inviteLogin" ){
        debugPrint("inviteLogin >> call.arguments = ${call.arguments}");
        //invite?verifyToken=5ab88daa1e157
      }

      if (call.method == "autoRegistrationLogin") {
        debugPrint("autoRegistrationLogin >> call.arguments = ${call.arguments}");
        dynamic arguments = call.arguments;
        setState(() {
          _verifyToken = arguments['verifyToken'];
          debugPrint(
              "autoRegistrationLogin << verifyToken = ${arguments['verifyToken']}");
        });
        _performRegistrationConfirm();
      }


    });





    const bool isReleaseMode = const bool.fromEnvironment("dart.vm.product");
    print("verifyToken:${widget.verifyToken}");
    if (_verifyToken!=null){
       _performRegistrationConfirm();
    }


    if (isReleaseMode) {
      _email1 = "";
      _email2 = "";
      _password1 = "";
      _password2 = "";
    } else {
      int _timestamp=new DateTime.now().millisecondsSinceEpoch;
      _email1 = "antonino.bajeli+${_timestamp}@gmail.com";
      _email2 = _email1;
      _password1 = "antonino";
      _password2 = _password1;
    }
  }


  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      setState(() => sending = true);
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _performRegistration();
    }
  }



  _performRegistrationConfirm() async {
    debugPrint("  verifyToken = $_verifyToken");
    IsaTutenze userToLogin = new IsaTutenze();
    userToLogin.gen_login_tkn=_verifyToken;

    RequestEnvelop envelop = new RequestEnvelop();
    envelop.userToLogin = userToLogin;
    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData,'getRegConfirm');
    if (!mounted) return;

    setState(() {
      sending = false;
      ResponseEnvelop i = new ResponseEnvelop.fromJson(json.decode(resultData));
      _user=i.user;

      widget.onChangedUser(i);
    });
  }


  _performRegistration() async {
    IsaTutenze userToLogin = new IsaTutenze();
    userToLogin.gen_email = _email1;
    userToLogin.gen_pwd = _password1;
    userToLogin.gen_scu = "";

    RequestEnvelop envelop = new RequestEnvelop();
    envelop.userToLogin = userToLogin;
    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData,'getRegistration');
    if (!mounted) return;

    setState(() {
      sending = false;
      ResponseEnvelop i = new ResponseEnvelop.fromJson(json.decode(resultData));
      _user=i.user;

      widget.onChangedUser(i);

    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    lcontext = context;
    debugPrint("Registration->build super.widget.key${super.widget.key}");
    Image _bkgImg = new Image(
      image: new AssetImage("assets/isa_logo.png"),
      fit: BoxFit.none,
      color: Colors.white70,
      colorBlendMode: BlendMode.dstOut,
    );

    TextStyle _labelTextStyle =
    new TextStyle(color: Colors.teal, fontSize: 20.0);
    InputDecorationTheme _inpDecTheme =
    new InputDecorationTheme(labelStyle: _labelTextStyle);


    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("Registrazione InfoScuolApp"),
        elevation:  defaultTargetPlatform == TargetPlatform.android  ? 5.0 : 0.0,
        actions: <Widget>[
          /*new IconButton(
                icon: new Icon(Icons.home),
                onPressed: () {
                  _goHome();
                }),
            new IconButton(
                icon: new Icon(Icons.exit_to_app),
                onPressed: () {
                  _logout();
                })*/
        ],
      ),



      body:  new Stack(fit: StackFit.expand, children: <Widget>[
        _bkgImg,
        new Form(
          key: _formKey,
          child: new Theme(
            data: new ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.teal,
                primaryColor: Colors.teal,
                inputDecorationTheme: _inpDecTheme),
            child: new Container(
              padding: const EdgeInsets.all(20.0),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new TextFormField(
                      //controller: _user,
                      decoration: new InputDecoration(labelText: "Email"),
                      initialValue: _email1,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                      !val.contains('@') ? 'Email non valida' : null,
                      onSaved: (val) => _email1 = val,
                      //controller: _emailCtrl1,
                    ),
                    new TextFormField(
                      //controller: _user,
                      decoration: new InputDecoration(labelText: "Conferma Email"),
                      initialValue: _email2,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                      (!(val==_email1) ) ? 'La email non coincidono' : null,
                      onSaved: (val) => _email2 = val,
                      //controller: _emailCtrl2,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(labelText: "Password"),
                      initialValue: _password1,
                      keyboardType: TextInputType.text,
                      validator: (val) =>
                      val.length < 6 ? 'Password troppo corta.' : null,
                      onSaved: (val) => _password1 = val,
                      obscureText: true,
                      //controller: _psswdCtrl1,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(labelText: "Conferma Password"),
                      initialValue: _password1,
                      keyboardType: TextInputType.text,
                      validator: (val) =>
                      !(val==_password1) ? 'Le Password non coincidono' : null,
                      onSaved: (val) => _password1 = val,
                      obscureText: true,
                      //controller: _psswdCtrl2,
                    ),
                    new Padding(padding: const EdgeInsets.only(top: 20.0)),
                    sending
                        ? new CircularProgressIndicator()
                        : new MaterialButton(
                      color: Colors.teal,
                      textColor: Colors.white70,
                      child: new Icon(Icons.arrow_forward),
                      onPressed: () {
                        _submit();
                      },
                      splashColor: Colors.redAccent,
                    ),
                  ]),
            ),
          ),
        )
      ]),
    )
    ;
  }
}
