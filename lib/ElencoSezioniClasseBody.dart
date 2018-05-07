import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:info_scuol_app/AddClasseDialog2.dart';

import 'package:info_scuol_app/model/IsaTutenze.dart';
import 'dart:async';
import 'model/RequestEnvelop.dart';
import 'model/ResponseEnvelop.dart';
import 'model/Alunno.dart';
import 'model/Scuola.dart';
import 'model/Classe.dart';
import 'model/Enums.dart';
import 'dart:convert';
import 'package:info_scuol_app/util/Network.dart';

// riferimenti
// https://codingwithjoe.com/building-forms-with-flutter/

class ElencoSezioniClasseBody extends StatefulWidget {
  ElencoSezioniClasseBody({Key key, this.scuola, this.ordinaleClasse})
      : super(key: key);

  static const String routeName = "/ElencoSezioniClasseBody";
  final Scuola scuola;
  final OrdinaliClassi ordinaleClasse;

  
  
  @override
  _ElencoSezioniClasseBodyState createState() =>
      new _ElencoSezioniClasseBodyState();
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
class _ElencoSezioniClasseBodyState extends State<ElencoSezioniClasseBody> {
  //List<String> _sezioniList = <String>['I A','I B','I C','D'];
  List<Classe> _sezioniList=new  List<Classe>();

  final List<SezioneItemWidget> _infoWidget = <SezioneItemWidget>[];
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
        title: new Text('Elenco sezioni "${widget.ordinaleClasse}" classi'),
      ),

      body: new RefreshIndicator(
          child: new ListView.builder(
            itemBuilder: _itemBuilder,
            //itemBuilder: (_, int index) => _infos[index],
            itemCount: _sezioniList.length,
          ),
          onRefresh: _onRefresh),

      // new ToDoItemWidget(),

      
      floatingActionButton:
              new FloatingActionButton(
                  //onPressed: _openDialogAddAlunnoItem,
                  onPressed: _openDialogAddSezioneItem,
                  tooltip: 'Add',
                  child: new Icon(Icons.add),
                ),
    );
  }

  
  Widget _itemBuilder(BuildContext context, int index) {
    Classe sezioneClasse = _sezioniList[index];

    
    return new SezioneItemWidget(
      sezioneClasse: sezioneClasse,
      ordinaleClasse: widget.ordinaleClasse
    );
  }



  Future<Null> _onRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    /*Timer t = new Timer(new Duration(seconds: 3), () {
      completer.complete(null);
    });*/
    _getSezioniClasseList();
    return completer.future;
  }


  Future _openDialogAddSezioneItem() async {
    RequestEnvelop valToSave =
    await Navigator.of(context).push(new MaterialPageRoute<RequestEnvelop>(
        builder: (BuildContext context) {
          return new AddClasseDialog.add(
              0, "17/18", widget.scuola,widget.ordinaleClasse);
        },
        fullscreenDialog: true));
    debugPrint("Returning conrol to Elenco Sezioni ._openAddClasseDialog");
    if (valToSave != null) {
      debugPrint("Val tu save");
      _onRefresh();

      //_addClasseSave(valToSave);
    }
  }




  _getSezioniClasseList() async {
    RequestEnvelop envelop = new RequestEnvelop();

    envelop.scu_codice=widget.scuola.scu_codice;
    envelop.scu_id=widget.scuola.scu_id;

    envelop.classe=new Classe();
    envelop.classe.cla_ordinale=widget.ordinaleClasse;

    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData,'getElencoSezioniClasse');
    if (!mounted) return;

    setState(() {
      //sending = false;
      ResponseEnvelop i = new ResponseEnvelop.fromJson(json.decode(resultData));
      _sezioniList=i.classi;

      //widget.onChangedUser(_user);
    });
  }


}






class SezioneItemWidget extends StatefulWidget {
  SezioneItemWidget({Key key, this.sezioneClasse, this.ordinaleClasse}): super(key: key);

    final Classe sezioneClasse;
    final OrdinaliClassi ordinaleClasse;

    //final IsaTutenze rappresentante;
    @override
    _SezioneItemWidgetState createState() => new _SezioneItemWidgetState();

}

class _SezioneItemWidgetState extends State<SezioneItemWidget> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new ListTile(
      leading: const Icon(Icons.account_box),
      title: new Text(
        "${OrdinaliClassiGetShortDescription(widget.ordinaleClasse)} ${widget.sezioneClasse.cla_sezione}",
       /* style: new TextStyle(
            color: (widget.alunno.genitori.elementAt(0).gen_id ==
                    widget.user.gen_id)
                ? theme.accentColor
                : theme.primaryColorDark),*/
      ),
      subtitle:
      widget.sezioneClasse.capoclasse!=null?
      (widget.sezioneClasse.capoclasse.cpcl_email.length > 1)
          ? new Text(
              "Rappresentante: ${widget.sezioneClasse.capoclasse.cpcl_email} ")
          : new Text(
              "Rappresentante: Nonn definito  "):null,

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
