import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:info_scuol_app/ComunicatoChat.dart';
import 'package:info_scuol_app/AddInfoItemDialog.dart';
import 'package:info_scuol_app/util/Network.dart';
import 'package:info_scuol_app/model/Info.dart';
import 'package:info_scuol_app/model/RequestEnvelop.dart';
import 'package:info_scuol_app/model/ResponseEnvelop.dart';
import 'package:info_scuol_app/model/InfoResp.dart';
import 'package:info_scuol_app/model/Classe.dart';
import 'package:info_scuol_app/model/IsaTutenze.dart';


class ElencoComunicatiBody extends StatefulWidget {
  ElencoComunicatiBody({Key key, this.title, this.user, this.classe}) : super(key: key);

  static const String routeName = "/ElencoComunicatiBody";
  final String title;
  final IsaTutenze user;
  final Classe classe;

  @override
  _ElencoComunicatiBodyState createState() => new _ElencoComunicatiBodyState();






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
class _ElencoComunicatiBodyState extends State<ElencoComunicatiBody> {
  List<Info> _infos = <Info>[];
  int cla_id ;

  final List<ToDoItemWidget> _infoWidget = <ToDoItemWidget>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cla_id==widget.classe.cla_id;
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
              itemCount: _infos.length,

          ),
          onRefresh: _onRefresh),

      // new ToDoItemWidget(),



      floatingActionButton:
      (widget.classe.capoclasse.cpcl_id != widget.user.gen_id)
          ? null
          : new FloatingActionButton(
        onPressed: _openDialogAddCominicatoItem,
        tooltip: 'Add',
        child: new Icon(Icons.add),
      ),
    );
  }



  Widget _itemBuilder(BuildContext context, int index) {
    Info info = _infos[index];

    return new ToDoItemWidget(
      info: info,
      user: widget.user,
      cla_id: widget.classe.cla_id,
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
    _getInfoList();
    return completer.future;
  }




  _getInfoList() async {
    RequestEnvelop envelop = new RequestEnvelop();
    envelop.ute_id = widget.user.gen_id;
    envelop.cla_id=widget.classe.cla_id;
    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData,'getInfos');
    if (!mounted) return;

    setState(() {
      //sending = false;
      InfoResp i = new InfoResp.fromJson(json.decode(resultData));
      _infos=i.response;

      //widget.onChangedUser(_user);
    });
  }



  Future _openDialogAddCominicatoItem() async {
    Info info =
    await Navigator.of(context).push(new MaterialPageRoute<Info>(
        builder: (BuildContext context) {
          return new AddInfoItemDialog.add(widget.classe.cla_id);
        },
        fullscreenDialog: true));

    if (info != null) {
      setState(() {
        _serviceSetInfoItem(info);

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









class ToDoItemWidget extends StatefulWidget {
  ToDoItemWidget({Key key, this.info, this.user,this.cla_id}) : super(key: key);

  final Info info;

  final IsaTutenze user;
  final int cla_id;
  @override
  _ToDoItemWidgetState createState() => new _ToDoItemWidgetState();
}






class _ToDoItemWidgetState extends State<ToDoItemWidget> {
  @override
  Widget build(BuildContext context) {

    return new

      ListTile(
      leading: const Icon(Icons.insert_comment),
      //leading: new Text('-'),
      title: new Text(widget.info.inf_titolo+ (widget.info.infrcp_read ?"R":"*NR*")+ (widget.info.inf_adesione ?"AD??":"")),
      subtitle: new Text("Del:"+widget.info.inf_date_start.toString() +" Data oggetto:"+widget.info.inf_date_end.toString() + widget.info.inf_descr),
      dense: widget.info.infrcp_read ,
      onTap: _onTap,
      onLongPress: _onLongPress,
    );
  }

  void _onTap() {
    Route route = new MaterialPageRoute(
        settings: new RouteSettings(name: "/comunicazioni/comunicazione"),
        builder: (BuildContext context) => new ChatScreen(
              info: widget.info,
              user: widget.user,
            ));
    Navigator.push(context, route);
  }


  void _onLongPress(){
    widget.info.inf_cla_id=widget.cla_id;
    _openDialogEditCominicatoItem(widget.info);
  }


  Future _openDialogEditCominicatoItem(Info info) async {

     info = await Navigator.of(context).push(new MaterialPageRoute<Info>(
        builder: (BuildContext context) {
          return new AddInfoItemDialog.edit(info);
        },
        fullscreenDialog: true));

    if (info != null) {
      setState(() {
        // remove
        //add
        _serviceSetInfoItem(info);
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