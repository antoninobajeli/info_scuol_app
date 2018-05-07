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

//https://github.com/MSzalek-Mobile/weight_tracker/tree/v0.2.1/lib
//https://marcinszalek.pl/flutter/flutter-fullscreendialog-tutorial-weighttracker-ii/
//https://material.io/guidelines/components/lists.html#lists-specs

class AddClasseDialog extends StatefulWidget {
  final int uteId;
  final String initialAnno;
  final String initialCodIst;
  final Scuola initialScuola;
  final String initialDescr;
  final String initialIban;
  final RequestEnvelop requestEnvelopToEdit;

  AddClasseDialog.add(this.uteId, this.initialAnno, this.initialCodIst)
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
          requestEnvelopToEdit.classe.scuola.istituto.ist_codice,
          requestEnvelopToEdit.classe.scuola,
          requestEnvelopToEdit.classe.cla_descr,
          requestEnvelopToEdit.classe.cla_anno,
          requestEnvelopToEdit.classe.cla_iban_fondocassa,
          true);
    } else {
      // NEW ITEM
      return new AddClasseDialogState(uteId, 0, initialCodIst, initialScuola,
          initialDescr, initialAnno, initialIban, false);
    }
  }
}

class AddClasseDialogState extends State<AddClasseDialog> {
  int uteId = 0;
  int _cla_id = 0;
  String _cod_ist = "cod ist";
  String _descr_classe = "descr";
  Scuola _scuola = new Scuola();
  String _anno;
  String _iban;
  List<String> _classi = new List<String>();
  List<Scuola> _scuole = new List<Scuola>();
  bool _editing = false;

  RequestEnvelop requestEnvelopToEdit;

  TextEditingController _textController;

  AddClasseDialogState(this.uteId, this._cla_id, this._cod_ist, this._scuola,
      this._descr_classe, this._anno, this._iban, this._editing);

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      title: widget.requestEnvelopToEdit == null
          ? const Text("Creazione classe")
          : const Text("Modifica Classe"),
      actions: [
        new FlatButton(
          onPressed: () {
            _submit();
          },
          child: ((_scuola == null) || (_descr_classe == null))
              ? null
              : new Icon(Icons.check,
    color: Theme.of(context).platform == TargetPlatform.iOS?
    Colors.blueAccent:
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
              leading: new Icon(Icons.today, color: Colors.grey[500]),
              title: new Text('Codice Istituto : $_cod_ist'),
            ),
            new ListTile(
              leading:
                  new Icon(Icons.format_list_bulleted, color: Colors.grey[500]),
              title: new Text('Anno scolastico $_anno'),
            ),


            new ListTile(
              leading: new Icon(Icons.home, color: Colors.grey[500]),
              title: new IgnorePointer(
                ignoring: _editing ? true : false,
                child: (_scuole.length == 0)
                    ? new Text("Caricamento in corso ")
                    : new DropdownButton(
                        hint: new Text("Seleziona scuola/plesso"),
                        value: _scuola,
                        items: _scuole.map((Scuola scuolaItem) {
                          return new DropdownMenuItem(
                              value: scuolaItem,
                              child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*new ListTile(
                            leading: new Icon(Icons.home, color: Colors.grey[500]),
                            title: new Text("${scuolaItem.scu_nome} "),
                          ),*/
                                    new Row(
                                      children: <Widget>[
                                        new Text("${scuolaItem.scu_nome} ")
                                      ],
                                    ),
                                    new Row(children: <Widget>[
                                      new Text(
                                        "${scuolaItem.scu_codice} ${scuolaItem.scu_tipo}",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 10.0),
                                      )
                                    ]),
                                  ]));
                        }).toList(),
                        onChanged: (Scuola selectedScuola) {
                          setState(() {
                            _scuola = selectedScuola;
                          });
                        }),
              ),
            ),
            new ListTile(
              leading: new Icon(Icons.home),
              title: new IgnorePointer(
                ignoring: _editing ? true : false,
                child: new DropdownButton(
                    hint: new Text("Seleziona la classe"),
                    value: _descr_classe,
                    items: _classi.map((String value) {
                      return new DropdownMenuItem(
                          value: value,
                          child: new Column(children: [
                            new Row(
                              children: <Widget>[new Text("Classe $value")],
                            )
                          ]));
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        _descr_classe = newValue;
                      });
                    }),
              ),
            ),
            new ListTile(
              leading:
                  new Icon(Icons.add_shopping_cart, color: Colors.grey[500]),
              title: new TextField(
                decoration: new InputDecoration(
                  hintText: 'IBAN ',
                ),
                controller: _textController,
                onChanged: (value) => _iban = value,
              ),
              onTap: () => _showWeightPicker(context),
            ),

/*
          new ListTile(
            leading: new Icon.asset(
              "assets/scale-bathroom.png",
              color: Colors.grey[500],
              height: 24.0,
              width: 24.0,
            ),
            title: new Text(
              "$_anno kg",
            ),
            onTap: () => _showWeightPicker(context),
          ),
*/

/*
          new ListTile(
            leading: new Icon(Icons.backup, color: Colors.grey[500]),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: 'Optional note',
              ),
              controller: _textController,
              onChanged: (value) => _iban = value,
            ),
          ),*/
          ],
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
    RequestEnvelop reqEnv = new RequestEnvelop();
    reqEnv.ute_id = uteId;
    reqEnv.sessionToken = null;
    reqEnv.ist_codice = _cod_ist;

    Classe cl = new Classe();

    cl.cla_id = _cla_id;
    cl.cla_anno = _anno;
    cl.cla_descr = _descr_classe;
    cl.cla_iban_fondocassa = _iban;
    cl.scuola = _scuola;

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

  _getScuoleList() async {
    RequestEnvelop envelop = new RequestEnvelop();
    envelop.ute_id = widget.uteId;
    envelop.sessionToken = null;
    envelop.ist_codice = _cod_ist;
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

  _showWeightPicker(BuildContext context) {
    showDialog(
      context: context,
      child: new NumberPickerDialog.decimal(
        minValue: 1,
        maxValue: 150,
        initialDoubleValue: 0.0,
        title: new Text("Enter your weight"),
      ),
    ).then((value) {
      if (value != null) {
        setState(() => _anno = value);
      }
    });
  }
}

class DateTimeItem extends StatelessWidget {
  DateTimeItem({Key key, DateTime dateTime, @required this.onChanged})
      : assert(onChanged != null),
        date = dateTime == null
            ? new DateTime.now()
            : new DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = dateTime == null
            ? new DateTime.now()
            : new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new InkWell(
            onTap: (() => _showDatePicker(context)),
            child: new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new Text(new DateFormat('EEEE, MMMM d').format(date))),
          ),
        ),
        new InkWell(
          onTap: (() => _showTimePicker(context)),
          child: new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new Text('$time')),
        ),
      ],
    );
  }

  Future _showDatePicker(BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date.subtract(const Duration(days: 20000)),
        lastDate: new DateTime.now());

    if (dateTimePicked != null) {
      onChanged(new DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute));
    }
  }

  Future _showTimePicker(BuildContext context) async {
    TimeOfDay timeOfDay =
        await showTimePicker(context: context, initialTime: time);

    if (timeOfDay != null) {
      onChanged(new DateTime(
          date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute));
    }
  }
}
