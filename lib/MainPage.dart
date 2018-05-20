import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';



//import 'package:get_version/get_version.dart';
//import 'package:flutter_plugin_app_version/flutter_plugin_app_version.dart';
import 'package:info_scuol_app/model/Enums.dart';
import 'package:info_scuol_app/model/IsaTutenze.dart';
import 'package:info_scuol_app/model/Figlio.dart';
import 'package:info_scuol_app/ElencoScuoleBody.dart';
import 'package:info_scuol_app/ElencoComunicatiBody.dart';
import 'package:info_scuol_app/ElencoAlunniClasseBody.dart';
import 'package:info_scuol_app/model/Alunno.dart';
import 'package:info_scuol_app/util/Network.dart';
import 'package:info_scuol_app/model/RequestEnvelop.dart';
import 'package:info_scuol_app/model/ResponseEnvelop.dart';
import 'package:info_scuol_app/model/Classe.dart';
import 'package:info_scuol_app/model/Scuola.dart';
import 'package:info_scuol_app/AddClasseDialog.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.verifyToken,this.devicePushTokenGl,this.devicePushTokenItune, this.title, this.user, this.figli})
      : super(key: key);
  static const String routeName = "/MainPage";
  final String title;
  final String verifyToken;
  final String devicePushTokenGl;
  final String devicePushTokenItune;
  final IsaTutenze user;
  final List<Figlio> figli;

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

///
///



class _MainPageState extends State<MainPage> {
  IsaTutenze _user;
  List<Figlio> _figli;
  List<Scuola> _scuole;
  Classe _classe;
  String _nome;
  String _classe_descr;
  WorkingMode currentRole = WorkingMode.genitore;
  String _appVersion = 'Unknown';
  String _appVersion2 = 'Unknown';
  String _platformVersion='Unknown ';


  static MethodChannel  channel_version= const MethodChannel("getVersionChannel");

  static Future<String> get appVersionNameFuture async {
    final String version = await channel_version.invokeMethod('getAppVersionName');
    return version;
  }
  static Future<String> get platformVersionFuture async {
    final String version = await channel_version.invokeMethod('getPlatformVersion');
    return version;
  }



  @override
  void initState() {
    // TODO: implement initState
    debugPrint("_MainPageState >> TODO: implement initState");
    super.initState();



    if (widget.verifyToken != null && _user == null) {
      _performRegistrationConfirm();
      debugPrint("_MainPageState >> _performRegistrationConfirm");

    } else {
      currentRole = WorkingMode.genitore;
      _user = widget.user;
      if (((_user != null) && (_user.gen_leader))||
          ((_classe!=null)&&(_classe.capoclasse.cpcl_id==_user.gen_id))){
        currentRole = WorkingMode.rappresentante;
      }
      _figli = widget.figli;


    }

    initPlatformState();
  }



  void _updatePushNotificationToken({String genPushTokenGl: "", String genPushTokenItune: ""}) async {
    IsaTutenze userToLogin = new IsaTutenze();
    userToLogin.gen_id=_user.gen_id;
    userToLogin.gen_push_token_gl= genPushTokenGl;
    userToLogin.gen_push_token_itune= genPushTokenItune;

    RequestEnvelop envelop = new RequestEnvelop();
    envelop.userToLogin = userToLogin;
    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData,'updatePushToken');
    if (!mounted) return;

    setState(() {
      try {
        ResponseEnvelop i = new ResponseEnvelop.fromJson(json.decode(resultData));

        print("UpdatePushNotificatioToken:" + resultData);
      }catch (e) {
        debugPrint(e.toString());
      }
    });
  }



  _performRegistrationConfirm() async {
    debugPrint("  verifyToken = ${widget.verifyToken}");
    IsaTutenze userToLogin = new IsaTutenze();
    userToLogin.gen_login_tkn = widget.verifyToken;
    userToLogin.gen_push_token_gl = widget.devicePushTokenGl;
    userToLogin.gen_push_token_itune = widget.devicePushTokenItune;

    RequestEnvelop envelop = new RequestEnvelop();
    envelop.userToLogin = userToLogin;
    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData, 'getRegConfirm');
    if (!mounted) return;

    setState(() {
      ResponseEnvelop i = new ResponseEnvelop.fromJson(json.decode(resultData));
      _user = i.user;
      _figli = i.figli;
      _scuole = i.scuole;


      _updatePushNotificationToken(genPushTokenGl:widget.devicePushTokenGl,genPushTokenItune:widget.devicePushTokenGl);
      //Navigator.pushNamed(context,"/");
      //_onChangedUser(i);
    });
  }


  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String appVersionName;
    try {
      appVersionName = await appVersionNameFuture;
    } on PlatformException {
      appVersionName = 'Failed to get app version name.';
    }


    String platformVersion;
    try {
      platformVersion = await platformVersionFuture;
    } on PlatformException {
      platformVersion = 'Failed to get app version name.';
    }

    setState(() {
      _appVersion = appVersionName;
      _platformVersion=platformVersion;
    });

  }


 bool fixingdata=false;


  @override
  Widget build(BuildContext context) {


     if (_user!=null){

      _nome = (_user.gen_cognome != null ? _user.gen_cognome : '') +
          ' ' +
          (_user.gen_nome != null ? _user.gen_nome : '');

      if ((_classe == null) && (_figli.length > 0)) {
        _classe_descr = _figli.elementAt(0).classe.cla_descr;
        _classe = _figli.elementAt(0).classe;
      } else {
        if(_classe!=null)
            _classe_descr = _classe.cla_descr;
        else
           _classe_descr="undefined";
      }
       if ((!fixingdata)&&((_user.gen_cell == null) || (_user.gen_cell.length < 1))) {
         fixingdata=true;
         _openDialogEditAlunnoItem();
       }

      if (((_user.gen_leader != null) && (_user.gen_leader))||
          ((_classe!=null)&&(_classe.capoclasse.cpcl_id==_user.gen_id))){
        currentRole = WorkingMode.rappresentante;
      }

      if ((_scuole!=null )&& (_scuole.length>0)){
        currentRole = WorkingMode.dirigente;
      }


      debugPrint("_MainPageState >> ${_user.gen_email}");


     }

    return



      new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      drawer: _user == null
          ? new Drawer()
          : new Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the Drawer if there isn't enough vertical
              // space to fit everything.
              child: new ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  /*new DrawerHeader(
              child: new Text('Drawer Header'),
              decoration: new BoxDecoration(
                color: Colors.blue,
              ),
            ),*/
                  new UserAccountsDrawerHeader(
                    accountName: new Text("$_nome ${_user.gen_id}"),
                    accountEmail: new Text(_user.gen_email),
                    currentAccountPicture: new CircleAvatar(
                      backgroundColor:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Colors.blueAccent
                              : Colors.white,
                      child: new Text("P"),
                    ),
                    otherAccountsPictures: <Widget>[
                      new CircleAvatar(
                        backgroundColor:
                            Theme.of(context).platform == TargetPlatform.iOS
                                ? Colors.blueAccent
                                : Colors.white,
                        child: new Text("K"),
                      ),
                    ],
                  ),
                  new ListTile(
                    title: new Text('Comunicati'),
                    trailing: new Icon(Icons.format_list_bulleted),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context); // chiude il drawer
                      // Navigator.pushNamed(context,'/ElencoComunicatiBody');
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  (_figli.length == 0)
                                      ? null
                                      : new ElencoComunicatiBody(
                                          title:
                                              "Elenco Comunicati ${_figli.elementAt(0).classe.cla_descr}",
                                          user: _user,
                                          classe: _figli.elementAt(0).classe,
                                        )));
                    },
                  ),


                  _scuole!=null?
                  new ListTile(
                    title: new Text('Scuole ${_scuole.length}'),
                    trailing: new Icon(Icons.format_list_bulleted),
                    onTap: () {
                      Navigator.pop(context); // chiude il drawer
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                              (_scuole.length == 0)
                                  ? null
                                  : new ElencoScuoleBody(
                                title:
                                "Elenco Scuole ${_scuole.elementAt(0).istituto.ist_nome}",
                                user: _user,
                                istituto: _scuole.elementAt(0).istituto,
                              )));
                    },
                  ):new ListTile(),





                  new ListTile(
                    title: new Text('Tuoi dati'),

                    trailing: new Icon(Icons.contacts),
                    onTap: () {
                      _openDialogEditAlunnoItem();
                    },
                  ),
                  new ListTile(
                    title: new Text('Info'),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);

                      _openDialogInfo();


                    },
                  ),


                  new ListTile(
                    title: new Text('Chiudi menu'),
                    trailing: new Icon(Icons.close),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.of(context).pop();
                    },
                  ),


                  new ListTile(
                    title: new Text('Esci'),
                    trailing: new Icon(Icons.exit_to_app),
                    onTap: ()=> exit(0),
                  ),



                ],
              ),
            ),
      body: new Builder(builder: (BuildContext context) {
        return
          (currentRole == WorkingMode.dirigente)?
          _createDirigenteCardInfo():
          (currentRole == WorkingMode.rappresentante)?
                _createReppresentanteCardInfo():
                _createGenitoreCardInfo();


      }),
      floatingActionButton: ((_classe != null) || (_user == null))
          ? null
          : currentRole == WorkingMode.rappresentante
              ? new FloatingActionButton(
                  onPressed: _openAddClasseDialog,
                  tooltip: 'Add',
                  child: new Icon(Icons.add),
                )
              : null,
    );
  }

  Future _openEditClasseDialog(Classe classe) async {
    RequestEnvelop reqEnv = new RequestEnvelop();
    reqEnv.ute_id = _user.gen_id;
    reqEnv.classe = classe;
    //reqEnv.sessionToken=getGen_login_tkn());
    reqEnv.ist_codice = classe.scuola.istituto.ist_codice;

    RequestEnvelop valToSave =
        await Navigator.of(context).push(new MaterialPageRoute<RequestEnvelop>(
            builder: (BuildContext context) {
              return new AddClasseDialog.edit(
                  _user.gen_id, reqEnv, classe.scuola);
            },
            fullscreenDialog: true));
    debugPrint("Returning conrol to MainPage._openEditClasseDialog");
    if (valToSave != null) {
      _addClasseSave(valToSave);
    }
  }

  Future _openAddClasseDialog() async {
    /*RequestEnvelop reqEnv=new RequestEnvelop();
    reqEnv.setUte_id(getUser().getGen_id());
    reqEnv.setSessionToken(getUser().getGen_login_tkn());
    reqEnv.setIst_codice(mCodIst.getText().toString());*/

    RequestEnvelop valToSave =
        await Navigator.of(context).push(new MaterialPageRoute<RequestEnvelop>(
            builder: (BuildContext context) {
              return new AddClasseDialog.add(
                  _user.gen_id, "17/18", "CTIC885009");
            },
            fullscreenDialog: true));
    debugPrint("Returning conrol to MainPage._openAddClasseDialog");
    if (valToSave != null) {
      _addClasseSave(valToSave);
    }
  }

  void _addClasseSave(RequestEnvelop classeSave) {
    setState(() {
      _classe_descr = classeSave.classe.cla_descr;
      _classe = classeSave.classe;
      /*
      weightSaves.add(weightSave);
      _listViewScrollController.animateTo(
        weightSaves.length * _itemExtent,
        duration: const Duration(microseconds: 1),
        curve: new ElasticInCurve(0.01),
      );*/
    });
  }


  Future _showDatePicker(BuildContext context) async {

  }




  Future _openDialogInfo() async {
    Navigator.of(context).push(new MaterialPageRoute<Alunno>(
        builder: (BuildContext context) {
          return new DialogEditInfo();
        },
        fullscreenDialog: true));
  }


    Future _openDialogEditAlunnoItem() async {
    Figlio figlio=_figli.elementAt(0);

    Alunno al=new Alunno();
    al.genitori=new List<IsaTutenze>();
    al.genitori.add(_user);
    al.claalu_cla_id=_classe.cla_id;
    al.alu_id=figlio.alu_id;
    al.alu_nome=figlio.alu_nome;
    al.alu_cognome=figlio.alu_cognome;
    al.alu_nascita=figlio.alu_nascita;

    Alunno data =
    await Navigator.of(context).push(new MaterialPageRoute<Alunno>(
        builder: (BuildContext context) {
          return new DialogEditAlunnoItem.edit(al);
        },
        fullscreenDialog: true));

    if (data != null) {
      setState(() {
        _user.gen_cognome=data.genitori.elementAt(0).gen_cognome;
        _user.gen_nome=data.genitori.elementAt(0).gen_nome;
        _user.gen_cell=data.genitori.elementAt(0).gen_cell;
        _figli.elementAt(0).alu_cognome=data.alu_cognome;
        _figli.elementAt(0).alu_nome=data.alu_nome;

        /*_alunniList.add(data);*/
        _serviceSetAlunnoGenitore(data);
      });
    }
    fixingdata=false;
  }



  _serviceSetAlunnoGenitore(Alunno alunno) async {
    RequestEnvelop reqEnv = new RequestEnvelop();
    reqEnv.ute_id = _user.gen_id;
    reqEnv.sessionToken = null;
    reqEnv.newAlunno = alunno;

    String reqData = json.encode(reqEnv.toJson());
    Network n = new Network();
    var resultData = await n.getDataTask(reqData, 'setAlunnoClasse');
    if (!mounted) return;
    setState(() {
      ResponseEnvelop resp =
      new ResponseEnvelop.fromJson(json.decode(resultData));
      if (resp.success) {
        showDialog(
            context: context,
            child: new SimpleDialog(
              title: new Text('MEMORIZZAZIONE RIUSCITA '),
            ));
      } else {
        showDialog(
            context: context,
            child: new SimpleDialog(
              title: new Text('MEMORIZZAZIONE FALLITA ${resp.message}'),
            ));
      }
    });
  }

  Card _createGenitoreCardInfo() {
    final theme = Theme.of(context);
    return _figli == null
        ? new Card()
        : new Card(
            child: (_figli.length == 0)
                ? null
                : new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text(
                          "Ruolo >> genitore di: ${_figli.elementAt(0).alu_nome}"),
                      new CachedNetworkImage(
                        placeholder: new CircularProgressIndicator(),
                        imageUrl:
                            'http://www.parinict.it/wp-content/uploads/2012/09/logo1.png',
                        width: 600.0,
                        height: 120.0,
                        fit: BoxFit.scaleDown,
                      ),
                      new ListTile(
                        leading: new Icon(Icons.settings),
                        title: new Text("Dir : " +
                            _figli
                                .elementAt(0)
                                .classe
                                .scuola
                                .istituto
                                .ist_dirigente),
                        subtitle: new Text("COD : " +
                            _figli
                                .elementAt(0)
                                .classe
                                .scuola
                                .istituto
                                .ist_codice +
                            '\n' +
                            "Email : " +
                            _figli
                                .elementAt(0)
                                .classe
                                .scuola
                                .istituto
                                .ist_email +
                            '\n' +
                            "IBAN : " +
                            _figli
                                .elementAt(0)
                                .classe
                                .scuola
                                .istituto
                                .ist_iban +
                            '\n' +
                            "Tel : " +
                            _figli.elementAt(0).classe.scuola.istituto.ist_tel +
                            '\n'),
                      ),
                      new ListTile(
                        leading: new Icon(Icons.format_list_bulleted),
                        title: new Text(" >> Classe " +
                            _classe_descr +
                            " " +
                            _figli.elementAt(0).classe.cla_anno),
                        subtitle: new Text(_figli
                                .elementAt(0)
                                .classe
                                .capoclasse
                                .cpcl_nome +
                            '\n' +
                            "Rappresentante_ " +
                            _figli.elementAt(0).classe.capoclasse.cpcl_nome +
                            " " +
                            _figli.elementAt(0).classe.capoclasse.cpcl_cognome +
                            '\n' +
                            "Email: " +
                            _figli.elementAt(0).classe.capoclasse.cpcl_email +
                            '\n' +
                            "IBAN Classe: " +
                            _figli.elementAt(0).classe.cla_iban_fondocassa +
                            '\n'),
                      ),
                      _createAppInfo(),
                      new ButtonTheme.bar(
                        // make buttons use the appropriate styles for cards
                        child: new ButtonBar(
                          children: <Widget>[
                            new FlatButton(
                              child: const Text('ELENCO ALUNNI'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new ElencoAlunniClasseBody(
                                              title:
                                                  "Elenco Alunni ${_classe.cla_descr}",
                                              user: _user,
                                              classe:
                                                  _figli.elementAt(0).classe,
                                            )));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
  }


  Card _createAppInfo() {
    final theme = Theme.of(context);
    return  new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          new ListTile(
            leading: new Icon(Icons.settings),
            title: new Text(
                "App : " + _appVersion + _appVersion2 ),
            subtitle: new Text("OS : " +_platformVersion),
          ),


        ],
      ),
    );

  }

  Card _createReppresentanteCardInfo() {
    final theme = Theme.of(context);
    return _classe_descr == null
        ? new Card()
        : new Card(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text("Ruolo : RAPPRESENTATE",
                    style: theme.textTheme.title
                        .copyWith(color: theme.primaryColorDark)),
                new CachedNetworkImage(
                  placeholder: new CircularProgressIndicator(),
                  imageUrl:
                      'http://www.parinict.it/wp-content/uploads/2012/09/logo1.png',
                  width: 600.0,
                  height: 120.0,
                  fit: BoxFit.scaleDown,
                ),
                new ListTile(
                  leading: new Icon(Icons.settings),
                  title: new Text(
                      "Dir : " + _classe.scuola.istituto.ist_dirigente),
                  subtitle: new Text("COD : " +
                      _classe.scuola.istituto.ist_codice +
                      '\n' +
                      "Email : " +
                      _classe.scuola.istituto.ist_email +
                      '\n' +
                      "IBAN : " +
                      _classe.scuola.istituto.ist_iban +
                      '\n' +
                      "Tel : " +
                      _classe.scuola.istituto.ist_tel +
                      '\n'),
                ),
                new ListTile(
                  leading: new Icon(Icons.format_list_bulleted),
                  title: new Text(
                      " >> Classe " + _classe_descr + " " + _classe.cla_anno),
                  subtitle: new Text(_classe.capoclasse.cpcl_nome +
                      '\n' +
                      "Rappresentante_ " +
                      _classe.capoclasse.cpcl_nome +
                      " " +
                      _classe.capoclasse.cpcl_cognome +
                      '\n' +
                      "Email: " +
                      _classe.capoclasse.cpcl_email +
                      '\n' +
                      "IBAN Classe: " +
                      _classe.cla_iban_fondocassa +
                      '\n'),
                ),
                _createAppInfo(),
                new ButtonTheme.bar(
                  // make buttons use the appropriate styles for cards
                  child: new ButtonBar(
                    children: <Widget>[
                      new FlatButton(
                        color: Colors.white,
                        child: new Icon(Icons.settings),
                        onPressed: () {
                          _openEditClasseDialog(_classe);
                        },
                      ),
                      new FlatButton(
                        color: Colors.white,
                        child: const Text('GESTIONE ISCRITTI'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new ElencoAlunniClasseBody(
                                        title:
                                            "Elenco Alunni ${_classe.cla_descr}",
                                        user: _user,
                                        classe: _figli.elementAt(0).classe,
                                      )));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );



  }




  Card _createDirigenteCardInfo() {
    final theme = Theme.of(context);
    return _classe_descr == null
        ? new Card()
        : new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text("Ruolo : DIRIGENTE",
              style: theme.textTheme.title
                  .copyWith(color: Colors.red)),
          new CachedNetworkImage(
            placeholder: new CircularProgressIndicator(),
            imageUrl:
            'http://www.parinict.it/wp-content/uploads/2012/09/logo1.png',
            width: 600.0,
            height: 120.0,
            fit: BoxFit.scaleDown,
          ),
          _scuole!=null?new ListTile(
            leading: new Icon(Icons.settings),
            title: new Text(
                "Dir : " + _scuole.elementAt(0).istituto.ist_dirigente),
            subtitle: new Text("COD : " +
                _scuole.elementAt(0).istituto.ist_codice +
                '\n' +
                "Email : " +
                _scuole.elementAt(0).istituto.ist_email +
                '\n' +
                "IBAN : " +
                _scuole.elementAt(0).istituto.ist_iban +
                '\n' +
                "Tel : " +
                _scuole.elementAt(0).istituto.ist_tel +
                '\n'),
          ):null,
          _createAppInfo(),

          _figli!=null?new ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: new ButtonBar(
              children: <Widget>[
                new FlatButton(
                  color: Colors.white,
                  child: new Icon(Icons.settings),
                  onPressed: () {
                    _openEditClasseDialog(_classe);
                  },
                ),
                new FlatButton(
                  color: Colors.white,
                  child: const Text('GESTIONE CLASSI E RAPPRESENTATI'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new ElencoAlunniClasseBody(
                              title:
                              "Elenco RAPPRESENTANTI ${_scuole.elementAt(0).scu_codice}",
                              user: _user,
                              classe: _figli.elementAt(0).classe,
                            )));
                  },
                ),
              ],
            ),
          ):null,
        ],
      ),
    );



  }




}



class DialogEditInfo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: const Text('App info'), actions: <Widget>[

      ]),
      body:  new ListView(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.tag_faces),
              title: new TextField(
                decoration: const InputDecoration(
                  labelText: "Nome",
                  hintText: "Inseriscri il nome di tuo figlio",
                ),

              ),
            ),


          ].toList(),

      ),
    );
  }

}




class DialogEditAlunnoItem extends StatefulWidget {
  Alunno aludata ;
  IsaTutenze genitore ;

  DialogEditAlunnoItem.edit(this.aludata ):genitore=aludata.genitori.elementAt(0);

  DialogEditAlunnoItem.add(){aludata=new Alunno();genitore=new IsaTutenze();}

  @override
  _DialogEditAlunnoItemState createState() {
    if ((aludata != null)&&(genitore != null)) {
      //EDITING
      return new _DialogEditAlunnoItemState(
          genitore,
          aludata,
          true);
    }}

}

class _DialogEditAlunnoItemState extends State<DialogEditAlunnoItem> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _canSave = false;
  bool _editing = false;
  Alunno _alunno;
  IsaTutenze _genitore ;
  TextEditingController _nomeAlunnoCtrl = new TextEditingController();
  TextEditingController _cognomeAlunnoCtrl = new TextEditingController();
  TextEditingController _nomeGen1Ctrl = new TextEditingController();
  TextEditingController _cognomeGen1Ctrl = new TextEditingController();
  TextEditingController _cellGen1Ctrl = new TextEditingController();

  FocusNode _textFocus = new FocusNode();

  _DialogEditAlunnoItemState(this._genitore, this._alunno, this._editing);

      @override
      void initState() {

        _nomeAlunnoCtrl.text=_alunno.alu_nome;
        _cognomeAlunnoCtrl.text=_alunno.alu_cognome;
        _nomeGen1Ctrl.text=_genitore.gen_nome;
        _cognomeGen1Ctrl.text=_genitore.gen_cognome;
        _cellGen1Ctrl.text=_genitore.gen_cell;

        _textFocus.addListener(onChange);
        // you can have different listner functions if you wish
        _nomeGen1Ctrl.addListener(onChange);
        _cognomeGen1Ctrl.addListener(onChange);
        _nomeAlunnoCtrl.addListener(onChange);
        _cognomeAlunnoCtrl.addListener(onChange);
        _cellGen1Ctrl.addListener(onChange);


      }

      void doSave() {
        final form = _formKey.currentState;

        if (form.validate()) {
          form.save();
          _alunno.genitori.clear();
          _alunno.genitori.add(_genitore);

          Navigator.of(context).pop(_alunno);
        }
      }

      void onChange() {
        _trySetCanSave();
      }

      void _trySetCanSave() {

        bool newSaveStatus = _nomeGen1Ctrl.text.isNotEmpty &&
            _cognomeGen1Ctrl.text.isNotEmpty &&
            _nomeAlunnoCtrl.text.isNotEmpty &&
            _cognomeAlunnoCtrl.text.isNotEmpty &&
            _cellGen1Ctrl.text.isNotEmpty;

        if (newSaveStatus != _canSave) setState(() => _canSave = newSaveStatus);
      }

      bool isValidEmail(String em) {
        String p =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
        RegExp regExp = new RegExp(p);
        return regExp.hasMatch(em);
      }

      @override
      Widget build(BuildContext context) {
        final ThemeData theme = Theme.of(context);
        return new Scaffold(
          appBar: new AppBar(title: const Text('Tuoi dati'), actions: <Widget>[
            new FlatButton(
                child: new Icon(Icons.check,
                    color:Theme.of(context).platform == TargetPlatform.iOS
                        ? (_canSave?Colors.blueAccent:Colors.white)
                        : (_canSave?Colors.white:Colors.blueAccent)),

                onPressed: _canSave
                    ? () {
                  doSave();
                }
                    : null)
          ]),
          body: new Form(
            key: _formKey,
            child: new ListView(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.tag_faces, color: theme.primaryColorDark),
                  title: new TextField(
                    decoration: const InputDecoration(
                      labelText: "Nome",
                      hintText: "Inseriscri il nome di tuo figlio",
                    ),
                    onChanged: (String value) {
                      _alunno.alu_nome = value;
                      //_setCanSave(value.isNotEmpty);
                    },
                    controller: _nomeAlunnoCtrl,
                  ),
                ),
                new ListTile(
                  leading:
                  new Icon(Icons.account_box, color: theme.primaryColorDark),
                  title: new TextField(
                    decoration: const InputDecoration(
                      labelText: "Cognome",
                      hintText: "Inserisci il cognome di tuo figlio",
                    ),
                    onChanged: (String value) {
                      _alunno.alu_cognome = value;
                      //_setCanSave(value.isNotEmpty);
                    },
                    controller: _cognomeAlunnoCtrl,
                  ),
                ),
                new Divider(
                  height: 32.0,
                  indent: 0.0,
                  color: theme.primaryColorDark,
                ),
                new Container(
                    child: new Flex(direction: Axis.horizontal, children: <Widget>[
                      new Icon(Icons.label, color: theme.primaryColorDark),
                      new Text("Tuoi dati",
                          style: new TextStyle(color: theme.primaryColorDark))
                    ])),
                new TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nome ",
                      hintText: "Inserisci il tuo nome",
                    ),
                    /*onChanged: (String value) {
                _gen1.gen_nome = value;
              },*/
                    onSaved: (val) => _genitore.gen_nome = val,
                    controller: _nomeGen1Ctrl),
                new TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Cognome ",
                      hintText: "Inserisci il tuo cognome ",
                    ),

                    onSaved: (val) => _genitore.gen_cognome = val,
                    controller: _cognomeGen1Ctrl),
                new TextFormField(
                  decoration: new InputDecoration(
                    labelText: "Telefono",
                    hintText: "Inserisci il numero di telefono del genitore",
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (val) => _genitore.gen_cell = val,
                  inputFormatters: [
                    new WhitelistingTextInputFormatter(
                        new RegExp(r'^[()\d -]{1,15}$')),
                  ],
                  controller: _cellGen1Ctrl,
                ),
              ].toList(),
            ),
          ),
        );
      }
    }

