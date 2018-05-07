import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:convert';
import 'package:info_scuol_app/util/Network.dart';
import 'package:info_scuol_app/model/Enums.dart';
import 'package:info_scuol_app/model/RequestEnvelop.dart';
import 'package:info_scuol_app/model/ResponseEnvelop.dart';
import 'package:info_scuol_app/model/Classe.dart';
import 'package:info_scuol_app/model/Scuola.dart';
import 'package:info_scuol_app/model/Capoclasse.dart';

//https://github.com/MSzalek-Mobile/weight_tracker/tree/v0.2.1/lib
//https://marcinszalek.pl/flutter/flutter-fullscreendialog-tutorial-weighttracker-ii/
//https://material.io/guidelines/components/lists.html#lists-specs

class AddClasseDialog extends StatefulWidget {
  final int uteId;
  final String initialAnno;
  final Scuola initialScuola;
  final String initialDescr;
  final OrdinaliClassi initialOrdinaleClasse;
  final RequestEnvelop requestEnvelopToEdit;

  AddClasseDialog.add(this.uteId, this.initialAnno, this.initialScuola,this.initialOrdinaleClasse)
      : requestEnvelopToEdit = null;

  AddClasseDialog.edit(
      this.uteId, this.requestEnvelopToEdit, this.initialScuola)
      : initialAnno = requestEnvelopToEdit.classe.cla_anno;

  @override
  AddClasseDialogState createState() {
    if (requestEnvelopToEdit != null) {
      //EDITING
      return new AddClasseDialogState(
          requestEnvelopToEdit.ute_id,
          requestEnvelopToEdit.classe.cla_id,
          requestEnvelopToEdit.classe.scuola,
          requestEnvelopToEdit.classe.cla_descr,
          requestEnvelopToEdit.classe.cla_anno,
          requestEnvelopToEdit.classe.cla_ordinale,
          true);
    } else {
      // NEW ITEM
      return new AddClasseDialogState(uteId, 0, initialScuola,
          initialDescr, initialAnno, initialOrdinaleClasse, false);
    }
  }
}

class AddClasseDialogState extends State<AddClasseDialog> {
  int uteId = 0;
  int _cla_id = 0;
  String _cla_sezione = "";
  String _email_capoclasse ="";
  OrdinaliClassi _cla_ordinale;
  String _descr_classe = "";
  Scuola _scuola = new Scuola();
  String _anno;
  bool _editing = false;

  RequestEnvelop requestEnvelopToEdit;

  TextEditingController _textController;

  AddClasseDialogState(this.uteId, this._cla_id, this._scuola,
      this._descr_classe, this._anno, this._cla_ordinale, this._editing);

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      title: widget.requestEnvelopToEdit == null
          ? Text("Nuova sez per classe ${_cla_ordinale}")
          : const Text("Modifica Classe"),
      actions: [
        new FlatButton(
          onPressed: () {
            _submit();
          },

          child: new Icon(Icons.check,
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
    //debugPrint("scuola ${_scuola_in.scu_id}");
    _textController = new TextEditingController(text: _cla_sezione);
    debugPrint("_ordinaleClasse ${_cla_ordinale}");
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
              leading: new Icon(Icons.code, color: Colors.grey[500]),
              title: new Text('Codice Istituto : ${_scuola.istituto.ist_codice}'),
            ),
            new ListTile(
              leading: new Icon(Icons.code, color: Colors.grey[500]),
              title: new Text('Codice Scuola : ${_scuola.scu_codice}'),
            ),
            new ListTile(
              leading:
              new Icon(Icons.format_list_bulleted, color: Colors.grey[500]),
              title: new Text('Anno scolastico $_anno'),
            ),


            new ListTile(
              leading: new Icon(Icons.home),
              title: new IgnorePointer(
                ignoring: _editing ? true : false,
                child: new TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Sezione",
                      hintText: "Inserisci la lettara della sezione",
                    ),
                    controller: _textController,
                    validator: (val) => val.isEmpty ? 'Sezione non valida' : null,
                    onSaved:  (val) => _cla_sezione = val,
                        /*
                        (String newVal) {
                      if (newVal.length <= 2) {
                        _cla_sezione = newVal.toUpperCase();
                        _textController.text = _cla_sezione;
                        debugPrint("1 $newVal");
                      } else {
                        debugPrint("2 $newVal");
                        _textController.text = _cla_sezione.toUpperCase();
                      }
                      setState(() {

                      });
                    }*/

                ),
              ),
            ),


            new ListTile(
              leading:
              new Icon(Icons.email, color: Colors.grey[500]),
              title: new TextFormField(
                decoration: const InputDecoration(
                  labelText: "Email rappresentate",
                  hintText: "email del rappresentate di classe",
                ),
                onSaved:  (val) => _email_capoclasse =val.toLowerCase(),

              ),
            ),


          ],
        ),
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;

    debugPrint("Validating");
    if (form.validate()) {
      setState(() => sending = true);
      form.save();
      _setClasse();
    }
  }

  bool sending = false;



  _setClasse() async {
    RequestEnvelop reqEnv = new RequestEnvelop();
    reqEnv.ute_id = uteId;
    reqEnv.sessionToken = null;
    //reqEnv.ist_codice = _scuola.istituto.ist_codice;

    Classe cl = new Classe();

    cl.cla_id = _cla_id;

    cl.cla_ordinale = _cla_ordinale;
    cl.cla_anno = _anno;
    cl.cla_sezione =_cla_sezione;
    cl.cla_descr = "$_cla_ordinale "+_cla_sezione;
    cl.cla_iban_fondocassa = "";
    cl.scuola = _scuola;

    cl.capoclasse=new Capoclasse();
    cl.capoclasse.cpcl_email=_email_capoclasse;
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
  }



}