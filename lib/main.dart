import 'package:flutter/material.dart';

import 'package:info_scuol_app/InfoScuolApp.dart';


// operazioeni di rilascio
//flutter build apk (flutter build defaults to --release)
//flutter build ios




/*
per la generazione dei modelli
 ../../Documents/FlutterSDK/flutter/bin/flutter packages pub run build_runner watch
 */

/*
adb shell am start -W -a android.intent.action.VIEW -d "yourscheme://yourhost/yellow/brick/road" com.yourcompany.deeplink
*/


// Evoluzione https://marcinszalek.pl/flutter/flutter-fullscreendialog-tutorial-weighttracker-ii/





/*
*
* final MethodChannel channel = const MethodChannel("com.myproject/url");

  String _url;

  @override
  initState() {
    super.initState();

    channel.setMethodCallHandler((MethodCall call) async {
      debugPrint("setMethodCallHandler call = $call");

      if (call.method == "openURL") {
        setState(() => _url = call.arguments["url"]);
      }
    });
  }
  */




void main() => runApp(

    new InfoScuolApp()
);



/*

class LoginNew extends StatefulWidget{
  const LoginNew ({
    Key key,
    @required this.onLoggedIn,
  }) : super(key: key);

  final VoidCallback onLoggedIn;
  @override
  _LoginNewState createState() => new _LoginNewState(onLoggedInState:(){onLoggedIn();});
}



class _LoginNewState extends State<LoginNew> {
  _LoginNewState({
    GlobalKey pscaffoldKey,
    @required this.onLoggedInState,
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
  final TextEditingController _emailCtrl = new TextEditingController();
  String _email;
  final TextEditingController _psswdCtrl = new TextEditingController();
  String _password;

  bool sending = false;

  IsaTutenze _user;


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
      _user=i.user;

      onLoggedInState();
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
      ]),
    )
    ;
  }
}





*/
