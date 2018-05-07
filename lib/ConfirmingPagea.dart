import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:info_scuol_app/model/IsaTutenze.dart';
import 'model/Figlio.dart';
import 'ElencoComunicatiBody.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:info_scuol_app/util/Network.dart';
import 'package:info_scuol_app/model/RequestEnvelop.dart';
import 'package:info_scuol_app/model/ResponseEnvelop.dart';

class ConfirmingPage extends StatefulWidget {
  ConfirmingPage({Key key, this.verifyToken, this.user, this.figli}) : super(key: key);
  static const String routeName = "/ConfirmingPage";
  final String verifyToken;
  final IsaTutenze user;
  final List<Figlio> figli;

  @override
  _ConfirmingPageState createState() => new _ConfirmingPageState();
}

/// // 1. After the page has been created, register it with the app routes
/// routes: <String, WidgetBuilder>{
///   ConfirmingPage.routeName: (BuildContext context) => new ConfirmingPage(title: "ConfirmingPage"),
/// },
///
/// // 2. Then this could be used to navigate to the page.
/// Navigator.pushNamed(context, ConfirmingPage.routeName);
///

///
class _ConfirmingPageState extends State<ConfirmingPage> {
  String _nome;
  String _classe_descr;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nome = (widget.user.gen_cognome != null ? widget.user.gen_cognome : '') +
        ' ' +
        (widget.user.gen_nome != null ? widget.user.gen_nome : '');

    if (widget.figli.length>0) {
      _classe_descr = widget.figli
          .elementAt(0)
          .classe
          .cla_descr;
    }else{
      _classe_descr=null;
    }

    debugPrint("_ConfirmingPageState >> ${widget.user.gen_email}");
    _performRegistrationConfirm();
  }


  _performRegistrationConfirm() async {
    debugPrint("  verifyToken = ${widget.verifyToken}");
    IsaTutenze userToLogin = new IsaTutenze();
    userToLogin.gen_login_tkn=widget.verifyToken;

    RequestEnvelop envelop = new RequestEnvelop();
    envelop.userToLogin = userToLogin;
    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData,'getRegConfirm');
    if (!mounted) return;

    setState(() {
      ResponseEnvelop i = new ResponseEnvelop.fromJson(json.decode(resultData));
      //_user=i.user;
      Navigator.pushNamed(context,"/");
      //_onChangedUser(i);
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("zzzz confirm page"),
      ),
      drawer: new Drawer(
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
              accountName: new Text(_nome),
              accountEmail: new Text(widget.user.gen_email),
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
              title: new Text('Comunicazioni'),
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
                           (widget.figli.length==0)?null: new ElencoComunicatiBody(
                              title: "Elenco Comunicati ${widget.figli.elementAt(0).classe.cla_descr}",
                              user: widget.user,
                              classe: widget.figli.elementAt(0).classe,
                            )));
              },
            ),
            new ListTile(
              title: new Text('Info'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            new ListTile(
              title: new Text('Chiudi'),
              trailing: new Icon(Icons.close),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),

      body:
    new Builder(
    builder: (BuildContext context) {
      return
      new Card(
        child: (widget.figli.length == 0) ? null : new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
              title: new Text("Dir : " + widget.figli
                  .elementAt(0)
                  .classe
                  .scuola
                  .istituto
                  .ist_dirigente),
              subtitle: new Text("COD : " + widget.figli
                  .elementAt(0)
                  .classe
                  .scuola
                  .istituto
                  .ist_codice + '\n' +
                  "Email : " + widget.figli
                  .elementAt(0)
                  .classe
                  .scuola
                  .istituto
                  .ist_email + '\n' +
                  "IBAN : " + widget.figli
                  .elementAt(0)
                  .classe
                  .scuola
                  .istituto
                  .ist_iban + '\n' +
                  "Tel : " + widget.figli
                  .elementAt(0)
                  .classe
                  .scuola
                  .istituto
                  .ist_tel + '\n'),
            ),
            new ListTile(
              leading: new Icon(Icons.format_list_bulleted),
              title: new Text(widget.figli
                  .elementAt(0)
                  .alu_nome + " >> Classe " + _classe_descr + " " + widget.figli
                  .elementAt(0)
                  .classe
                  .cla_anno),
              subtitle: new Text(widget.figli
                  .elementAt(0)
                  .classe
                  .capoclasse
                  .cpcl_nome + '\n' +
                  "Rappresentante_ " + widget.figli
                  .elementAt(0)
                  .classe
                  .capoclasse
                  .cpcl_nome +
                  " " + widget.figli
                  .elementAt(0)
                  .classe
                  .capoclasse
                  .cpcl_cognome + '\n' +
                  "Email: " + widget.figli
                  .elementAt(0)
                  .classe
                  .capoclasse
                  .cpcl_email + '\n' +
                  "IBAN Classe: " + widget.figli
                  .elementAt(0)
                  .classe
                  .cla_iban_fondocassa + '\n'
              ),
            ),

            new ButtonTheme
                .bar( // make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: const Text('Cofigura Classe'),
                    onPressed: () {
                      /* ... */
                    },
                  ),
                  new FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () {
                      /* ... */
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );

    }),

    );
  }
}
