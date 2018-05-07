import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:info_scuol_app/model/IsaTutenze.dart';
import 'package:info_scuol_app/ElencoComunicatiBody.dart';
import 'package:info_scuol_app/MainPage.dart';
import 'package:info_scuol_app/Login.dart';
import 'package:info_scuol_app/Registration.dart';
import 'package:info_scuol_app/model/ResponseEnvelop.dart';

import 'dart:async';
import 'dart:convert';
import 'package:info_scuol_app/util/Network.dart';
import 'package:info_scuol_app/model/RequestEnvelop.dart';



final loginNewKeyState = new GlobalKey();
final registrationKeyState = new GlobalKey();
final registrationInitialKeyState = new GlobalKey();


class InfoScuolApp extends StatefulWidget {

  _InfoScuolAppState createState() => new _InfoScuolAppState();
  var a=debugPrint("InfoScuolApp");
}


class _InfoScuolAppState extends State<InfoScuolApp> {
  // This widget is the root of your application.
  String title = "titolo";
  LoginNew _loginStack;
  Registration _registrationStack;
  //MyHomePage _loginOldPage ;

  IsaTutenze _user ;
  ResponseEnvelop _responseEnvelop ;
  Widget _screen;
  Widget _mainPage;
  String _verifyToken;

  // infoscuolapp://com.bajeli.infoscuolapp/registration
  final MethodChannel channel = const MethodChannel("deeplink.channel/registration");



  static MethodChannel  channel2= const MethodChannel("get_version");
  static Future<String> get appVersionNameFuture async {
    final String version = await channel2.invokeMethod('getAppVersionName');
    return version;
  }


  @override
  initState() {
    super.initState();
    /*debugPrint("loginNewKeyState :$loginNewKeyState");
    debugPrint("registrationKeyState :$registrationKeyState");
    debugPrint("registrationInitialKeyState :$registrationInitialKeyState");*/
    debugPrint("InfoScuolAppState >> initState");


    channel.setMethodCallHandler((MethodCall call) async {
      debugPrint("setMethodCallHandler call = $call");

      if (call.method == "inviteLogin" ){
        debugPrint("inviteLogin >> call.arguments = ${call.arguments}");
        //invite?verifyToken=5ab88daa1e157
      }

      if (call.method == "autoRegistrationLogin") {
        dynamic arguments = call.arguments;
        _verifyToken = arguments['verifyToken'];
/*
        var parts = settings.name.split('?').elementAt(1).split('=');
        if (parts.elementAt(0) == 'verifyToken'){
          var verifyToken=parts.elementAt(1);
          return new MaterialPageRoute(
              builder: (BuildContext ctx) =>
              new Registration(
                  key: registrationKeyState,
                  verifyToken:verifyToken,
                  onChangedUser: _onChangedUser
              )
          );
*/


        //_performRegistrationConfirm();


        setState(() {
          debugPrint("Pushing Registration >> _verifyToken = ${_verifyToken}");

          _mainPage =
          new MainPage(
            title: "Pannello di controllo deep method",
            verifyToken:_verifyToken,
            user: null,
            figli: null,
          );
          _screen = _mainPage;
        });




/*
        Navigator.push(_context,
            new MaterialPageRoute(
                builder: (BuildContext ctx) =>
                new Registration(
                    key: registrationKeyState,
                    verifyToken:_verifyToken,
                    onChangedUser: _onChangedUser
                )
            )
        );
        debugPrint("Pushing _screen");
        Navigator.push(_context,
            new MaterialPageRoute( builder: (_context) => _screen)
        );*/
      }

    });


  }


  _InfoScuolAppState() {
    debugPrint("InfoScuolAppState >> _InfoScuolAppState");
    //_loginOldPage=  new MyHomePage( title: 'Login page' );
    _loginStack = new LoginNew(
        key: loginNewKeyState,
        onLoggedIn: () {
          _onLoggeIn();
        },
        onChangedUser: _onChangedUser);

    /*_registrationStack = new Registration(
        key: registrationKeyState,
        onChangedUser: _onChangedUser
    );*/


    _screen = _loginStack;

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
      ResponseEnvelop i = new ResponseEnvelop.fromJson(json.decode(resultData));
      _user=i.user;
      Navigator.pushNamed(_context,"/");
      //_onChangedUser(i);
    });
  }






  // questo metodo viene chiamato dalla classe login non appena il valore viene impostato

  void _onChangedUser(response) {
    debugPrint("main._onChangedUser: ${response}");
    setState(() {
      _responseEnvelop = response;
      _user = _responseEnvelop.user;
      if ((_user != null) && (_user.gen_id > 0)) {
        _mainPage = new MainPage(
          title: "Pannello di controllo",
          user: _user,
          figli: _responseEnvelop.figli,
        );
        _screen = _mainPage;
        debugPrint("_onChangedUser context = $_context");

        //debugPrint(" Navigator.canPop :: ${Navigator.canPop(context.get)}");
      } else {}
    });
/*
    Navigator.push(
        _context,
        new MaterialPageRoute( builder: (_context) => _screen)
    );*/
  }

  // OBSOLETO, sotituito da _onChangedUser
  // questo metodo viene chiamato dalla classe login per indicare che
  // l'utente ha effettuato la login

  void _onLoggeIn() {
    /*
    setState(() {
      print("eccomi");
      _user=loginNewKeyState.currentState.getIsaTutenze();
      if ((_user!=null)&&(_user.gen_id>0)){
        _screen=_mainPage;
      }else{


      }

    });*/
  }

  Widget centeredText(String text) {
    return new Scaffold(body: new Center(child: new Text(text)));
  }

  BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context=context;
    debugPrint("InfoScuolApp->build   context :: $_context  _screen=> $_screen");

    final routes = <String, WidgetBuilder>{
      // Shown when launched with plain intent.
      '/': (BuildContext _context) => _screen,
      // Shown when launched with known deep link.
      '/reg': (BuildContext _context) => centeredText('Invite'),
      // Shown when launched with another known deep link.
      //'/registration': (BuildContext _context) => _registrationStack,
      ElencoComunicatiBody.routeName: (BuildContext _context) =>
      new ElencoComunicatiBody(title: "Elenco Comunicazioni"),
    };

    return new MaterialApp(

      title: 'Info Scuola App',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
        primaryColor: defaultTargetPlatform == TargetPlatform.iOS
            ? Colors.grey[50]
            : null,
      ),
      //home: _screen,
      //home: new MainPage(title: "MainPage1"),

      /*home: new MyHomePage(
           title: 'Login page'
       ),*/
      routes: routes,
      initialRoute: null,

      // Used when launched with unknown deep link.
      // May do programmatic parsing of routing path here.

      onGenerateRoute: _onGenerateRoute,
      /*(RouteSettings settings) => ({new MaterialPageRoute(

        builder: (BuildContext ctx) => centeredText('Not found'),
      )}),*/

      //home: new MyGetData(),
    );
  }




  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    debugPrint(" >>>>>> _onGenerateRoute ${settings.name}");
    var parts = settings.name.split('?').elementAt(1).split('=');
    if (parts.elementAt(0) == 'verifyToken'){
      _verifyToken=parts.elementAt(1);
      /*_mainPage =
      _screen = _mainPage;*/




      return new MaterialPageRoute(
          builder: (BuildContext _context) =>

            new MainPage(
              title: "Pannello di controllo",
              verifyToken:_verifyToken,
              user: null,
              figli: null,
            ),

      );
    }
    return new MaterialPageRoute(
      builder: (BuildContext _context) => null,
    );
  }
}

