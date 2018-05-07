import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:convert';
import 'package:info_scuol_app/util/Network.dart';
import 'package:info_scuol_app/model/RequestEnvelop.dart';
import 'package:info_scuol_app/model/ResponseEnvelop.dart';
import 'package:info_scuol_app/model/Classe.dart';
import 'package:info_scuol_app/model/Istituto.dart';
import 'package:info_scuol_app/model/Scuola.dart';
import 'package:info_scuol_app/ElencoSezioniClasseBody.dart';
import 'package:info_scuol_app/model/Enums.dart';

//https://github.com/MSzalek-Mobile/weight_tracker/tree/v0.2.1/lib
//https://marcinszalek.pl/flutter/flutter-fullscreendialog-tutorial-weighttracker-ii/
//https://material.io/guidelines/components/lists.html#lists-specs

class AddScuolaDialog extends StatefulWidget {
  final int uteId;
  final int ist_id;
  final String ist_codice;
  final String initialCodIst;
  final Scuola initialScuola;
  final String initialDescr;
  final String initialIban;
  Scuola scuola;

  AddScuolaDialog.add(this.uteId,this.ist_id,this.ist_codice){
    scuola=new Scuola();
    scuola.istituto=new Istituto();
    scuola.scu_id=0;
    scuola.istituto.ist_codice=ist_codice;
    scuola.scu_nome="";
    scuola.scu_tipo=TipoScuola.scuola_dell_infansia;
    scuola.scu_codice="CTEE88501B";
  }

  AddScuolaDialog.edit(this.uteId, this.scuola);


  @override
  AddScuolaDialogState createState() {
    if (scuola.scu_id==0) {
      //new ITEM
      return new AddScuolaDialogState(
          uteId,
          scuola,
          false);
    } else {
      // NEW EDIT
      return new AddScuolaDialogState(
          uteId,
          scuola,
          true);
    }
  }
}

class AddScuolaDialogState extends State<AddScuolaDialog> {


  int uteId = 0;
  int _scu_id;

  //String _cod_ist = "cod ist";
  String _descr_classe = "descr";
  Scuola _scuola = new Scuola();
  String _anno;
  String _iban;
  List<String> _classi = new List<String>.of(["1A", "1B", "1C"]);
  List<Scuola> _scuole = new List<Scuola>();
  bool _editing = false;

  RequestEnvelop requestEnvelopToEdit;

  TextEditingController _textController;

  AddScuolaDialogState(this.uteId,
      this._scuola,
      this._editing);

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      title: widget.scuola.scu_nome == null
          ? const Text("Nuova Scuola")
          : const Text("Modifica Scuola"),
      actions: [
        new FlatButton(
          onPressed: () {
            _submit();
          },
          child: ((_scuola == null) || (_descr_classe == null))
              ? null
              : new Icon(Icons.check,
            color: Theme
                .of(context)
                .platform == TargetPlatform.iOS ?
            Colors.blueAccent :
            Colors.white,

          ),
          /*
          new Text('SAVE',
              style: Theme
                  .of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white)
                  ),*/
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _classi.addAll(["1A", "1B", "1C"]);
    //debugPrint("scuola ${_scuola_in.scu_id}");
    _textController = new TextEditingController(text: _iban);
    _getScuoleList();
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _createAppBar(context),
      body: new Form(
        key: _formKey,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            new ListTile(
                leading:
                new Icon(Icons.account_balance, color: Colors.grey[500]),
                title:  new Text(
                    '${widget.scuola.scu_nome}'
                )
            ),

            new ListTile(
              leading: null,
              title:
              new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[

                new Expanded(
                  flex: 2,
                  child: new Text(

                      'Codice Istituto C. ${widget.scuola.istituto.ist_codice}',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                      color: Colors.redAccent))
                  ),

                new Icon(Icons.code, color: Colors.grey[500]),
                new Expanded(
                  flex: 2,
                  child:new Text(
                        'Codice Scuola ${widget.scuola.scu_codice}',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                    color: Colors.blueAccent))
                  ),




              ]
              ),

      ),

            new ListTile(
              leading: new Icon(Icons.home, color: Colors.grey[500]),
              title:  new Text(
                  '${TipoScuolaGetDescription(widget.scuola.scu_tipo)}'
              )
            ) ,


            new ListTile(
              leading:
              new Icon(Icons.date_range, color: Colors.grey[500]),
              title: new Text('Anno scolastico 2017/18'),
            ),

            _getTileForSezioni(OrdinaliClassi.I,widget.scuola,"A-B-C-D"),

            _getTileForSezioni(OrdinaliClassi.II,widget.scuola,"A-B-C-D"),

            _getTileForSezioni(OrdinaliClassi.III,widget.scuola,"A-B-C-D"),

        ((_scuola.scu_tipo == TipoScuola.scuola_primaria) ||
            (_scuola.scu_tipo == TipoScuola.scuola_superiore)) ?
        _getTileForSezioni(OrdinaliClassi.IV,widget.scuola,"A-B-C-D"):null,


        ((_scuola.scu_tipo == TipoScuola.scuola_primaria) ||
            (_scuola.scu_tipo == TipoScuola.scuola_superiore)) ?
            _getTileForSezioni(OrdinaliClassi.V,widget.scuola,"A-B-C-D"):null,


          ].where(notNull).toList(),
        ),
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      //setState(() => sending = true);
      form.save();
      _setClasse();
    }
  }

  bool sending = false;

  _setClasse() async {
    /*
    RequestEnvelop reqEnv = new RequestEnvelop();
    reqEnv.ute_id = uteId;
    reqEnv.sessionToken = null;
    reqEnv.ist_codice = _cod_ist;

    Scuola sc = new Scuola();

    sc.scu_id = _scu_id;
    sc.scu = _anno;
    sc.cla_descr = _descr_classe;
    sc.cla_iban_fondocassa = _iban;
    sc.scuola = _scuola;

    reqEnv.classe = cl;

    String reqData = json.encode(reqEnv.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData, 'setNewClasse');
    if (!mounted) return;

    setState(() {
      sending = false;

      ResponseEnvelop resp =
          new ResponseEnvelop.fromJson(json.decode(resultData));
      if (resp.success) {
        Navigator
            .of(context)
            //.pop(new RequestEnvelop(_descrizione, _anno, _iban));
            .pop(reqEnv);
      } else {
        showDialog(
            context: context,
            child: new SimpleDialog(
              title: new Text('MEMORIZZAZIONE FALLITA ${resp.message}'),
            ));
      }
    });
    */
  }


  ListTile _getTileForSezioni(OrdinaliClassi ordinaleClasse,Scuola scuola,String sezioni){
    String title=OrdinaliClassiGetDescription(ordinaleClasse);
    return new ListTile(
      leading: new Center(
        child: new Text("${OrdinaliClassiGetShortDescription(ordinaleClasse)}",
        style: new TextStyle(
            fontWeight: FontWeight.w500, fontSize: 25.0),)),

      title: new Text("Conf sezioni ${title} classi"),
      subtitle: new Text("${sezioni} "),

      onTap: ()=> _showSezioniClasse(scuola,ordinaleClasse),
    );
  }




  _getScuoleList() async {
    RequestEnvelop envelop = new RequestEnvelop();
    envelop.ute_id = widget.uteId;
    envelop.sessionToken = null;
    envelop.ist_codice = _scuola.istituto.ist_codice;
    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData, 'getElencoScuoleIstituto');
    if (!mounted) return;

    setState(() {
      //sending = false;

      Istituto ist = new Istituto.fromJson(json.decode(resultData));
      _scuole = ist.scuole;
      debugPrint("scuole.length ${_scuole.length}");

      if (_scuola != null)
        _scuola = _scuole.firstWhere((item) => item.scu_id == _scuola.scu_id);
      /*
      Scuola foundSc=_scuole.firstWhere( (item) => item.scu_id  == _scuola.scu_id );
      debugPrint("${_scuola.scu_id}");
      debugPrint("${_scuola.scu_codice}");
      debugPrint("${_scuola.scu_tipo}");
      debugPrint("${_scuola.scu_nome}");


      debugPrint("${foundSc.scu_id}");
      debugPrint("${foundSc.scu_codice}");
      debugPrint("${foundSc.scu_tipo}");
      debugPrint("${foundSc.scu_nome}");*/

      //widget.onChangedUser(_user);
    });
  }


  _showSezioniClasse(Scuola scuola,OrdinaliClassi ordinaleClasse){
   // String ordinaleClasse;
   // int id_ist;
    debugPrint("${scuola.scu_id} - ${ordinaleClasse} ");

    Route route = new MaterialPageRoute(
        settings: new RouteSettings(name: "/comunicazioni/comunicazione"),
        builder: (BuildContext context) => new ElencoSezioniClasseBody(
          scuola: scuola,
          ordinaleClasse: ordinaleClasse,
        ));
    Navigator.push(context, route);
  }



}