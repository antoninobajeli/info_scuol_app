
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:info_scuol_app/util/Network.dart';
import 'package:info_scuol_app/model/RequestEnvelop.dart';
import 'package:info_scuol_app/model/ResponseEnvelop.dart';
import 'package:info_scuol_app/model/IsaTutenze.dart';



class LoginNew extends StatefulWidget{
  const LoginNew ({
    Key key,
    @required this.onLoggedIn,
    @required this.onChangedUser,
  }) : super(key: key);

  final VoidCallback onLoggedIn;
  final ValueChanged<ResponseEnvelop> onChangedUser;

  @override
  _LoginNewState createState() => new _LoginNewState(onLoggedInState:(){onLoggedIn();});
}



class _LoginNewState extends State<LoginNew> {
  _LoginNewState({
    GlobalKey pscaffoldKey,
    @required this.onLoggedInState
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
  //final TextEditingController _emailCtrl = new TextEditingController();
  String _email="";
  //final TextEditingController _psswdCtrl = new TextEditingController();
  String _password="";

  bool sending = false;

  IsaTutenze _user;


  @override
  void initState() {

    super.initState();
    //print(_emailCtrl.text);
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


  _performLogin() async {
    IsaTutenze userToLogin = new IsaTutenze();
    userToLogin.gen_email = _email;
    userToLogin.gen_pwd = _password;

    RequestEnvelop envelop = new RequestEnvelop();
    envelop.userToLogin = userToLogin;
    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData,'getLogin');
    if (!mounted) return;

    setState(() {
      sending = false;
      try {
        ResponseEnvelop i = new ResponseEnvelop.fromJson(json.decode(resultData));
        _user = i.user;

        widget.onChangedUser(i);
        //onLoggedInState();

        showDialog(
            context: context,
            child: new SimpleDialog(
              title: new Text('Login OK: ' + i.figli
                  .elementAt(0)
                  .alu_cognome),
            ));

        print("cognome figlio:" + i.figli
            .elementAt(0)
            .alu_cognome);
      }catch (e) {
        debugPrint(e.toString());
      }
      //_ipAddress = i.figli.toString();
    });
  }


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


    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("InfoScuolApp Login"),
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
                      initialValue: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                      !val.contains('@') ? 'Not a valid email.' : null,
                      onSaved: (val) => _email = val,
                      //controller: _emailCtrl,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(labelText: "Password"),
                      initialValue: _password,
                      keyboardType: TextInputType.text,
                      validator: (val) =>
                      val.length < 6 ? 'Password too short.' : null,
                      onSaved: (val) => _password = val,
                      obscureText: true,
                      //controller: _psswdCtrl,
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
