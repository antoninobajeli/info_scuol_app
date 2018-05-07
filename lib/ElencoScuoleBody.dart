import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:info_scuol_app/AddScuolaDialog.dart';
import 'package:info_scuol_app/util/Network.dart';
import 'package:info_scuol_app/model/Info.dart';

import 'package:info_scuol_app/model/Scuola.dart';
import 'package:info_scuol_app/model/Istituto.dart';
import 'package:info_scuol_app/model/RequestEnvelop.dart';
import 'package:info_scuol_app/model/ResponseEnvelop.dart';
import 'package:info_scuol_app/model/InfoResp.dart';
import 'package:info_scuol_app/model/Classe.dart';
import 'package:info_scuol_app/model/IsaTutenze.dart';


class ElencoScuoleBody extends StatefulWidget {
  ElencoScuoleBody({Key key, this.title, this.user, this.istituto}) : super(key: key);

  static const String routeName = "/ElencoScuoleBody";
  final String title;
  final IsaTutenze user;
  final Istituto istituto;

  @override
  _ElencoScuoleBodyState createState() => new _ElencoScuoleBodyState();






}

/// // 1. After the page has been created, register it with the app routes
/// routes: <String, WidgetBuilder>{
///   ElencoScuoleBody.routeName: (BuildContext context) => new ElencoScuoleBody(title: "ElencoScuoleBody"),
/// },
///
/// // 2. Then this could be used to navigate to the page.
/// Navigator.pushNamed(context, ElencoScuoleBody.routeName);
///

///
class _ElencoScuoleBodyState extends State<ElencoScuoleBody> {
  List<Scuola> _scuole = <Scuola>[];
  int ist_id ;

  final List<ScuolaItemWidget> _scuolaWidget = <ScuolaItemWidget>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ist_id=widget.istituto.ist_id;
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ist_dir_tut_id ${widget.istituto.ist_dir_tut_id } <=> ${widget.user.gen_id} ');
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),

      body: new RefreshIndicator(
          child: new ListView.builder(
              itemBuilder: _itemBuilder,
              //itemBuilder: (_, int index) => _infos[index],
              itemCount: _scuole.length,

          ),
          onRefresh: _onRefresh),

      // new ToDoItemWidget(),



      floatingActionButton:
      (widget.istituto.ist_dir_tut_id == widget.user.gen_id)
          ?new FloatingActionButton(
        onPressed: _openDialogAddScuolaItem,
        tooltip: 'Add',
        child: new Icon(Icons.add),
      ):null,

    );
  }



  Widget _itemBuilder(BuildContext context, int index) {
    Scuola scuola = _scuole[index];

    return new ScuolaItemWidget(
      scuola: scuola,
      user: widget.user,
      scu_id: scuola.scu_id,
      istituto: widget.istituto,
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
    _getScuoleList();
    return completer.future;
  }




  _getScuoleList() async {
    RequestEnvelop envelop = new RequestEnvelop();
    envelop.ute_id = widget.user.gen_id;
    envelop.ist_codice=widget.istituto.ist_codice;

    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData,'getElencoScuoleIstituto');
    if (!mounted) return;

    setState(() {
      //sending = false;
      ResponseEnvelop i = new ResponseEnvelop.fromJson(json.decode(resultData));
      _scuole=i.scuole;

      //widget.onChangedUser(_user);
    });
  }



  Future _openDialogAddScuolaItem() async {

    debugPrint("widget.istituto.ist_codice ${widget.istituto.ist_codice}");
    Scuola scuola =
    await Navigator.of(context).push(new MaterialPageRoute<Scuola>(
        builder: (BuildContext context) {
          return new AddScuolaDialog.add(widget.user.gen_id,ist_id,widget.istituto.ist_codice);
        },
        fullscreenDialog: true));

    if (scuola != null) {
      setState(() {
        //_serviceSetInfoItem(scuola);

      });
    }

  }



  Future _serviceSetInfoItem(Info info) async {
    RequestEnvelop reqEnv = new RequestEnvelop();
    reqEnv.ute_id = widget.user.gen_id;
    reqEnv.sessionToken = null;
    reqEnv.newInfo=info;

    String reqData = json.encode(reqEnv.toJson());
    Network n = new Network();
    var resultData = await n.getDataTask(reqData, 'setInfo');
    if (!mounted) return;
    setState(() {
      debugPrint(resultData);
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

  /*
    Future _openDialogEditCominicatoItem(Info info) async {
      info =
      await Navigator.of(context).push(new MaterialPageRoute<Info>(
          builder: (BuildContext context) {
            return new AddInfoItemDialog.edit(info);
          },
          fullscreenDialog: true));

      if (info != null) {
        setState(() {
          /*_user.gen_cognome=data.genitori.elementAt(0).gen_cognome;
        _user.gen_nome=data.genitori.elementAt(0).gen_nome;
        _user.gen_cell=data.genitori.elementAt(0).gen_cell;
        _figli.elementAt(0).alu_cognome=data.alu_cognome;
        _figli.elementAt(0).alu_nome=data.alu_nome;*/

          /*_alunniList.add(data);*/
          // _serviceSetAlunnoGenitore(data);
        });
      }
    }*/




  }









class ScuolaItemWidget extends StatefulWidget {
  ScuolaItemWidget({Key key, this.scuola, this.user,this.scu_id,this.istituto}) : super(key: key);

  final Istituto istituto;
  final Scuola scuola;

  final IsaTutenze user;
  final int scu_id;
  @override
  _ScuolaItemWidgetState createState() => new _ScuolaItemWidgetState();
}






class _ScuolaItemWidgetState extends State<ScuolaItemWidget> {
  @override
  Widget build(BuildContext context) {

    return new

      ListTile(
      leading: const Icon(Icons.home),
      //leading: new Text('-'),
      title: new Text(widget.scuola.scu_nome ),
      subtitle: new Text(widget.scuola.scu_tipo.toString()),
      onTap: _onTap,
      onLongPress: _onLongPress,
    );
  }

  void _onTap() {
    /*
    Route route = new MaterialPageRoute(
        settings: new RouteSettings(name: "/scuole/scuola"),
        builder: (BuildContext context) => new ChatScreen(
              scuola: widget.scuola,
              user: widget.user,
            ));
    Navigator.push(context, route);*/
  }


  void _onLongPress(){
    widget.scuola.scu_id=widget.scu_id;
    widget.scuola.istituto=widget.istituto;
    _openDialogEditScuolaItem(widget.scuola);
  }


  Future _openDialogEditScuolaItem(Scuola scuola) async {


     scuola = await Navigator.of(context).push(new MaterialPageRoute<Scuola>(
        builder: (BuildContext context) {
          return new AddScuolaDialog.edit(widget.user.gen_id,scuola);
        },
        fullscreenDialog: true));

    if (scuola != null) {
      setState(() {
        // remove
        //add
        //_serviceSetInfoItem(info);
      });
    }


  }



  Future _serviceSetInfoItem(Info info) async {
    RequestEnvelop reqEnv = new RequestEnvelop();
    reqEnv.ute_id = widget.user.gen_id;
    reqEnv.sessionToken = null;
    reqEnv.newInfo=info;

    String reqData = json.encode(reqEnv.toJson());
    Network n = new Network();
    var resultData = await n.getDataTask(reqData, 'setInfo');
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