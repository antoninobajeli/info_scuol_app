import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:info_scuol_app/util/Network.dart';
import 'package:info_scuol_app/model/RequestEnvelop.dart';
import 'package:info_scuol_app/model/ResponseEnvelop.dart';
import 'package:info_scuol_app/model/IsaTutenze.dart';
import 'dart:convert';
import 'package:info_scuol_app/main.dart';



class Login5 extends StatefulWidget {
  Login5({
    Key key,
    this.title,
    @required this.onSubmit,}) : super(key: key);

  static const String routeName = "/Login5";

  final VoidCallback onSubmit;

  final String title;
  @override
  _Login5State createState() => new _Login5State(key);
}



class _Login5State extends State<Login5> {
  _Login5State(GlobalKey pscaffoldKey) {
    scaffoldKey = pscaffoldKey;
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey;

  final VoidCallback onSubmit;
  BuildContext lcontext;

  // controllers for form text controllers
  final TextEditingController _emailCtrl = new TextEditingController();
  String _email;
  final TextEditingController _psswdCtrl = new TextEditingController();
  String _password;

  @override
  void initState() {
    super.initState();
    print(_emailCtrl.text);
    const bool isReleaseMode = const bool.fromEnvironment("dart.vm.product");
    if (isReleaseMode) {
      _email = "";
      _password = "";
    } else {
      _email = "antonino.bajeli+1522048887326@gmail.com";
      _password = "antonino";
    }
  }



  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      setState(() => sending = true);
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _performLogin();
    }
  }

  void _performLoginOld() {
    // This is just a demo, so no actual login here.
    final snackbar = new SnackBar(
      content: new Text('Email: $_email, password: $_password'),
    );

    Scaffold.of(lcontext).showSnackBar(snackbar);
  }

  _performLogin() async {
    IsaTutenze userToLogin = new IsaTutenze();
    userToLogin.gen_email = _email;
    userToLogin.gen_pwd = _password;

    RequestEnvelop envelop = new RequestEnvelop();
    envelop.userToLogin = userToLogin;
    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData);
    if (!mounted) return;

    setState(() {
      sending = false;
      ResponseEnvelop i = new ResponseEnvelop.fromJson(json.decode(resultData));
      showDialog(
          context: context,
          child: new SimpleDialog(
            title: new Text('Login OK: '+i.figli.elementAt(0).alu_cognome),
          ));

      print("cognome figlio:" + i.figli.elementAt(0).alu_cognome);
      Navigator.of(lcontext).pushNamed( TestPAge.routeName);
      //_ipAddress = i.figli.toString();
    });
  }

  bool sending = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    lcontext = context;

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

    return new Stack(fit: StackFit.expand, children: <Widget>[
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
                    initialValue: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        !val.contains('@') ? 'Not a valid email.' : null,
                    onSaved: (val) => _email = val,
                    controller: _emailCtrl,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(labelText: "Password"),
                    initialValue: _password,
                    keyboardType: TextInputType.text,
                    validator: (val) =>
                        val.length < 6 ? 'Password too short.' : null,
                    onSaved: (val) => _password = val,
                    obscureText: true,
                    controller: _psswdCtrl,
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
    ]);
  }
}


