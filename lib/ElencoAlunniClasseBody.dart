import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:info_scuol_app/model/IsaTutenze.dart';
import 'dart:async';
import 'model/RequestEnvelop.dart';
import 'model/ResponseEnvelop.dart';
import 'model/Alunno.dart';
import 'model/Classe.dart';
import 'dart:convert';
import 'package:info_scuol_app/util/Network.dart';

// riferimenti
// https://codingwithjoe.com/building-forms-with-flutter/

class ElencoAlunniClasseBody extends StatefulWidget {
  ElencoAlunniClasseBody({Key key, this.title, this.user, this.classe})
      : super(key: key);

  static const String routeName = "/ElencoAlunniClasseBody";
  final String title;
  final IsaTutenze user;
  final Classe classe;

  @override
  _ElencoAlunniClasseBodyState createState() =>
      new _ElencoAlunniClasseBodyState();
}

/// // 1. After the page has been created, register it with the app routes
/// routes: <String, WidgetBuilder>{
///   ElencoComunicatiBody.routeName: (BuildContext context) => new ElencoComunicatiBody(title: "ElencoComunicatiBody"),
/// },
///
/// // 2. Then this could be used to navigate to the page.
/// Navigator.pushNamed(context, ElencoComunicatiBody.routeName);
///

///
class _ElencoAlunniClasseBodyState extends State<ElencoAlunniClasseBody> {
  List<Alunno> _alunniList = <Alunno>[];
  final List<AlunnoItemWidget> _infoWidget = <AlunnoItemWidget>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),

      body: new RefreshIndicator(
          child: new ListView.builder(
            itemBuilder: _itemBuilder,
            //itemBuilder: (_, int index) => _infos[index],
            itemCount: _alunniList.length,
          ),
          onRefresh: _onRefresh),

      // new ToDoItemWidget(),

      floatingActionButton:
          (widget.classe.capoclasse.cpcl_id != widget.user.gen_id)
              ? null
              : new FloatingActionButton(
                  onPressed: _openDialogAddAlunnoItem,
                  tooltip: 'Add',
                  child: new Icon(Icons.add),
                ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    Alunno alunno = _alunniList[index];

    return new AlunnoItemWidget(
      alunno: alunno,
      user: widget.user,
    );
  }

  /*
  Widget _itemBuilder(BuildContext context, int index) {
    Info info = getInfo(index);

    return new ToDoItemWidget(
      info: info,
      user: widget.user,
    );
  }
*/

/*
  Info getInfo(int index) {
    /*Info i = new Info();
    i.inf_titolo = "mio titolo ${index}";
    i.inf_descr = "descrizione ${index}";*/

    return i;
  }
*/

  Future<Null> _onRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    Timer t = new Timer(new Duration(seconds: 3), () {
      completer.complete(null);
    });
    _getElencoAlunniClasseList();
    return completer.future;
  }

  _getElencoAlunniClasseList() async {
    RequestEnvelop envelop = new RequestEnvelop();
    envelop.cla_id = widget.classe.cla_id;
    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData, 'getRegistroClasse');
    if (!mounted) return;

    setState(() {
      ResponseEnvelop resp =
          new ResponseEnvelop.fromJson(json.decode(resultData));
      _alunniList = resp.elencoclasse;

      //infos=i.response;

      //widget.onChangedUser(_user);
    });
  }

  Future _openDialogAddAlunnoItem() async {
    Alunno data =
        await Navigator.of(context).push(new MaterialPageRoute<Alunno>(
            builder: (BuildContext context) {
              return new DialogAddAlunnoItem();
            },
            fullscreenDialog: true));

    if (data != null) {
      setState(() {
        _alunniList.add(data);
        _serviceSetAlunnoClasse(data);
      });
    }
  }

  _serviceSetAlunnoClasse(Alunno alunno) async {
    alunno.claalu_cla_id = widget.classe.cla_id;
    RequestEnvelop reqEnv = new RequestEnvelop();
    reqEnv.ute_id = widget.user.gen_id;
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
}












class DialogAddAlunnoItem extends StatefulWidget {
  @override
  _DialogAddAlunnoItemState createState() => new _DialogAddAlunnoItemState();
}

class _DialogAddAlunnoItemState extends State<DialogAddAlunnoItem> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _canSave = false;
  Alunno _data = new Alunno();
  IsaTutenze _gen1 = new IsaTutenze();
  IsaTutenze _gen2 = new IsaTutenze();
  TextEditingController _nomeAlunnoCtrl = new TextEditingController();
  TextEditingController _cognomeAlunnoCtrl = new TextEditingController();
  TextEditingController _nomeGen1Ctrl = new TextEditingController();
  TextEditingController _cognomeGen1Ctrl = new TextEditingController();
  TextEditingController _emailGen1Ctrl = new TextEditingController();

  FocusNode _textFocus = new FocusNode();

  @override
  void initState() {
    _textFocus.addListener(onChange);
    // you can have different listner functions if you wish
    _nomeAlunnoCtrl.addListener(onChange);
    _cognomeAlunnoCtrl.addListener(onChange);
    _nomeGen1Ctrl.addListener(onChange);
    _cognomeGen1Ctrl.addListener(onChange);
    _emailGen1Ctrl.addListener(onChange);
  }

  void doSave() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      _data.genitori = new List<IsaTutenze>();
      _data.genitori.add(_gen1);

      if (_gen2.gen_nome != null) _data.genitori.add(_gen2);
      Navigator.of(context).pop(_data);
    }
  }

  void onChange() {
    String text = _emailGen1Ctrl.text;
    bool hasFocus = _textFocus.hasFocus;
    //_emailGen1Ctrl.text
    _trySetCanSave();
    //_setCanSave(_email1Controller.text.isNotEmpty);
    //do your text transforming
    //_email1Controller.text = newText;
    /*_email1Controller.selection = new TextSelection(
        baseOffset: newText.length,
        extentOffset: newText.length
    );*/
  }

  void _setCanSave(bool save) {
    if (save != _canSave) setState(() => _canSave = save);
  }

  void _trySetCanSave() {
    bool newSaveStatus = _nomeAlunnoCtrl.text.isNotEmpty &&
        //_cognomeAlunnoCtrl.text.isNotEmpty &&
        _emailGen1Ctrl.text.isNotEmpty;
        //_nomeGen1Ctrl.text.isNotEmpty &&
        //_cognomeGen1Ctrl.text.isNotEmpty ;

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
      appBar: new AppBar(
          title: const Text('Nuovo alunno'),
          actions: <Widget>[
            new FlatButton(
                child: new Icon(Icons.check,
                    //color: _canSave ? Colors.blueAccent : Colors.grey[500]),
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
                  hintText: "Nome Es. Mario",
                ),
                onChanged: (String value) {
                  _data.alu_nome = value;
                  //_setCanSave(value.isNotEmpty);
                },
                controller: _nomeAlunnoCtrl,
              ),
            ),

            /*
            new ListTile(
              leading:
                  new Icon(Icons.account_box, color: theme.primaryColorDark),
              title: new TextField(
                decoration: const InputDecoration(
                  labelText: "Cognome",
                  hintText: "Cognome Es. Rossi",
                ),
                onChanged: (String value) {
                  _data.alu_cognome = value;
                  //_setCanSave(value.isNotEmpty);
                },
                controller: _cognomeAlunnoCtrl,
              ),
            ),*/

            new Divider(
              height: 32.0,
              indent: 0.0,
              color: theme.primaryColorDark,
            ),
            new Container(
                child: new Flex(direction: Axis.horizontal, children: <Widget>[
              new Icon(Icons.label, color: theme.primaryColorDark),
              new Text("Primo genitore",
                  style: new TextStyle(color: theme.primaryColorDark))
            ])),

            /*
            new TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nome genitore",
                  hintText: "Inserisci il Nome del genitore",
                ),
                /*onChanged: (String value) {
                _gen1.gen_nome = value;
              },*/
                onSaved: (val) => _gen1.gen_nome = val,
                controller: _nomeGen1Ctrl),
            new TextFormField(
                decoration: const InputDecoration(
                  labelText: "Cognome genitore",
                  hintText: "Inserisci il cognome del genitore",
                ),
                /*onChanged: (String value) {
                _gen1.gen_nome = value;
              },*/
                onSaved: (val) => _gen1.gen_cognome = val,
                controller: _cognomeGen1Ctrl),

                */
            new TextFormField(
              decoration: const InputDecoration(
                labelText: "Email genitore",
                hintText: "Inserisci l'Email del genitore",
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (val) =>
                  !isValidEmail(val) ? 'Formato Email non valido' : null,
              onSaved: (val) => _gen1.gen_email = val,
              controller: _emailGen1Ctrl,
              focusNode: _textFocus,
              /*onChanged: (String value) {
                _gen1.gen_email = value;
              },*/
            ),


            /*
            new TextFormField(
              decoration: new InputDecoration(
                labelText: "Telefono",
                hintText: "Inserisci il numero di telefono del genitore",
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                new WhitelistingTextInputFormatter(
                    new RegExp(r'^[()\d -]{1,15}$')),
              ],
              */


              /*validator: (val) =>
          !val.contains('@') ? 'Not a valid email.' : null,*/
              //onSaved: (val) => _gen1.gen_email = val,
              //controller: _email1Controller,
              //focusNode: _textFocus,
              /*onChanged: (String value) {
                _gen1.gen_email = value;
                _setCanSave(value.isNotEmpty);
              },
            ),*/
            new Divider(
              height: 16.0,
              indent: 0.0,
              color: _canSave
                  ? theme.primaryColorDark
                  : theme.unselectedWidgetColor,
            ),


            new Container(
                child: new Flex(direction: Axis.horizontal, children: <Widget>[
              new Icon(Icons.label,
                  color: _canSave
                      ? theme.primaryColorDark
                      : theme.unselectedWidgetColor),

              new Text("Secondo genitore (opzionale)",
                  style: new TextStyle(
                      color: _canSave
                          ? theme.primaryColorDark
                          : theme.unselectedWidgetColor))
            ])),

            /*
            new TextField(
              decoration: const InputDecoration(
                labelText: "Nome genitore",
                hintText: "Inserisci il nome del genitore",
              ),
              enabled: _canSave,
              onChanged: (String value) {
                _gen2.gen_nome = value;
                //_setCanSave(value.isNotEmpty);
              },
            ),
            new TextField(
              decoration: const InputDecoration(
                labelText: "Cogome genitore",
                hintText: "Inserisci il cognome del genitore",
              ),
              enabled: _canSave,
              onChanged: (String value) {
                _gen2.gen_cognome = value;
                //_setCanSave(value.isNotEmpty);
              },
            ),

            */
            new TextField(
              decoration: const InputDecoration(
                labelText: "Email genitore",
                hintText: "(facoltativo) email genitore",
              ),
              enabled: _canSave,
              onChanged: (String value) {
                _gen2.gen_email = value;
                //_setCanSave(value.isNotEmpty);
              },
            ),





          ].toList(),
        ),
      ),
    );
  }
}

class AlunnoItemWidget extends StatefulWidget {
  AlunnoItemWidget({Key key, this.alunno, this.user}) : super(key: key);

  final Alunno alunno;

  final IsaTutenze user;
  @override
  _AlunnoItemWidgetState createState() => new _AlunnoItemWidgetState();
}

class _AlunnoItemWidgetState extends State<AlunnoItemWidget> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new ListTile(
      leading: const Icon(Icons.account_box),
      title: new Text(
        "${widget.alunno.alu_nome} ${widget.alunno.alu_cognome}",
        style: new TextStyle(
            color: (widget.alunno.genitori.elementAt(0).gen_id ==
                    widget.user.gen_id)
                ? theme.accentColor
                : theme.primaryColorDark),
      ),
      subtitle: (widget.alunno.genitori.length > 1)
          ? new Text(
              "Genitori: ${widget.alunno.genitori.elementAt(0).gen_nome} e ${widget.alunno.genitori.elementAt(1).gen_nome}")
          : new Text(
              "Genitore: ${widget.alunno.genitori.elementAt(0).gen_nome}  "),
      dense:
          !(widget.alunno.genitori.elementAt(0).gen_id == widget.user.gen_id),
      onTap: _onTap,
    );
  }

  void _onTap() {
    /*Route route = new MaterialPageRoute(
        settings: new RouteSettings(name: "/comunicazioni/comunicazione"),
        builder: (BuildContext context) => new ChatScreen(
              alunno: widget.alunno,
              user: widget.user,
            ));
    Navigator.push(context, route);*/
  }
}

/*
IsaTutenze user = new IsaTutenze();
                user.setGen_id(mUserId);
                user.setGen_login_tkn(mUsrLoginTkn);

                RequestEnvelop envelop = new RequestEnvelop();
                envelop.setUte_id(mUserId);
                envelop.setUserToLogin(user);
                envelop.setCla_id(((Figlio) getFigli().get(0)).getClasse().getCla_id());

                int responseCode;
                String tmpJson = null;
                try {
                    tmpJson = mapper.writeValueAsString(envelop);
                    Log.w("tmpJson", tmpJson);

                    URL url = NetworkUtils.buildUrl("/" + BuildConfig.SERVICE_END_POINT_PROVIDER, "getInfos");
                    String res = NetworkUtils.getJsonResponseFromHttpUrlAndJsonParams(url, tmpJson);
 */
