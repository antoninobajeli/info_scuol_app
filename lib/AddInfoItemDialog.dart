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
import 'package:info_scuol_app/model/Info.dart';
import 'package:info_scuol_app/DateTimePickerWidget.dart';

class AddInfoItemDialog extends StatefulWidget {
  Info infodata;
  int cla_id;
  String initialinf_titolo = "Titolo nuovo comunicato";

  AddInfoItemDialog.edit(this.infodata);

  AddInfoItemDialog.add(this.cla_id) {
    infodata = new Info();
    infodata.inf_id = 0;
    infodata.inf_cla_id=cla_id;
    infodata.inf_titolo = "";
    infodata.inf_descr = "";
    infodata.inf_categoria = 0;
    infodata.inf_priority = 0;
    infodata.inf_adesione = false;
    infodata.inf_date_start = new DateTime.now();
    infodata.inf_date_end = new DateTime.now();
    //genitore=new IsaTutenze();
  }

  @override
  _AddInfoItemDialogState createState() {
    if (infodata != null) {
      //EDITING
      /*infodata.inf_id,
      infodata.inf_titolo,
    infodata.inf_descr,
    infodata.inf_categoria,
    infodata.inf_priority,
    infodata.inf_adesione,
    infodata.inf_date_start,
    infodata.inf_date_end,*/
      return new _AddInfoItemDialogState(infodata, true);
    } else {
      return new _AddInfoItemDialogState(infodata, false);
    }
  }
}

class _AddInfoItemDialogState extends State<AddInfoItemDialog> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _canSave = false;
  bool _editing = false;
  Info _infodata;

  String initialinf_titolo;

  TextEditingController _inf_titoloCtrl = new TextEditingController();
  TextEditingController _inf_descrCtrl = new TextEditingController();
  TextEditingController _inf_categoriaCtrl = new TextEditingController();
  TextEditingController _inf_priorityCtrl = new TextEditingController();
  TextEditingController _inf_adesioneCtrl = new TextEditingController();
  TextEditingController _inf_date_startCtrl = new TextEditingController();
  TextEditingController _inf_date_endCtrl = new TextEditingController();

  FocusNode _textFocus = new FocusNode();
  //TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);
  TimeOfDay _fromTime, _toTime;

  final List<String> _allPriorities = <String>[
    '0',
    '1',
    '2',
    '3'
  ];
  String _priority = '4';

  final List<String> _allCategories = <String>[
    '0',
    '1',
    '2',
    '3',
    '4',
  ];
  String _category ;

  _AddInfoItemDialogState(this._infodata, this._editing);

  @override
  void initState() {
    _category="${_infodata.inf_categoria}";
    _priority="${_infodata.inf_priority}";

    _fromTime = new TimeOfDay(
        hour: _infodata.inf_date_start.hour,
        minute: _infodata.inf_date_start.minute);

    _toTime = new TimeOfDay(
        hour: _infodata.inf_date_end.hour,
        minute: _infodata.inf_date_end.minute);

    _inf_titoloCtrl.text = _infodata.inf_titolo;
    _inf_descrCtrl.text = _infodata.inf_descr;

    _textFocus.addListener(onChange);
    // you can have different listner functions if you wish
    _inf_titoloCtrl.addListener(onChange);
    _inf_descrCtrl.addListener(onChange);
    _inf_date_startCtrl.addListener(onChange);
    _inf_date_endCtrl.addListener(onChange);
  }

  void doSave() {
    final form = _formKey.currentState;

    if (form.validate()&&_editing) {
      form.save();
      debugPrint("start date ${_infodata.inf_date_start}");
      Navigator.of(context).pop(_infodata);
    }else{
      Navigator.of(context).pop(null);
    }
  }

  void onChange() {
    _trySetCanSave();
  }

  void _trySetCanSave() {
    bool newSaveStatus =
        _inf_titoloCtrl.text.isNotEmpty && _inf_descrCtrl.text.isNotEmpty;

    if (newSaveStatus != _canSave) setState(() => _canSave = newSaveStatus);
  }
  bool adesioni = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
        appBar:
            new AppBar(title: const Text('Dati comunicato'), actions: <Widget>[
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
        body: new MediaQuery(
          data: new MediaQueryData(alwaysUse24HourFormat: true),
          child: new Form(
            key: _formKey,
            child: new ListView(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Expanded(
                      flex: 3,
                      child: new InputDecorator(

                        decoration: const InputDecoration(
                          labelText: 'Priorita',
                          hintText: 'Seleziona priorità',
                        ),
                        isEmpty: _priority == null,
                        child: new DropdownButton<String>(
                          value: "${_infodata.inf_priority}",
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _infodata.inf_priority = int.parse(newValue);
                              _trySetCanSave();
                            });
                          },
                          items: _allPriorities.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    new Expanded(
                      flex: 4,
                      child: new InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                          hintText: 'Seleziona categoria',
                        ),
                        isEmpty: _category == null,
                        child: new DropdownButton<String>(
                          value: "${_infodata.inf_categoria}",
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _infodata.inf_categoria = int.parse(newValue);
                              _trySetCanSave();
                            });
                          },
                          items: _allCategories.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    new Expanded(
                      flex: 3,
                      child: new InputDecorator(
                        decoration: const InputDecoration(labelText: 'Adesioni'),
                        child: new Checkbox(
                            //tristate: true,

                            value: _infodata.inf_adesione,
                            onChanged: (bool value) {
                              setState(() {
                                _infodata.inf_adesione = value;
                                _trySetCanSave();
                              });

                            },

                            ),
                      ),
                    ),
                  ],
                ),
                new ListTile(
                  leading:
                      new Icon(Icons.message, color: theme.primaryColorDark),
                  title: new TextField(
                    decoration: const InputDecoration(
                      labelText: "Titolo",
                      hintText: "Inseriscri il titolo del comunicato",
                    ),
                    onChanged: (String value) {
                      _infodata.inf_titolo = value;
                      //_setCanSave(value.isNotEmpty);
                    },
                    controller: _inf_titoloCtrl,
                  ),
                ),
                new ListTile(
                  leading:
                      new Icon(Icons.keyboard, color: theme.primaryColorDark),
                  title: new TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: "Descrizione",
                      hintText:
                          "Inserisci descrizione dettagliata del comunicato",
                    ),
                    onChanged: (String value) {
                      _infodata.inf_descr = value;
                    },
                    controller: _inf_descrCtrl,
                  ),
                ),
                new ListTile(
                  leading:
                      new Icon(Icons.date_range, color: theme.primaryColorDark),
                  title: new DateTimePicker(
                    labelText: 'Dal',
                    selectedDate: _infodata.inf_date_start,
                    selectedTime: _fromTime,
                    selectDate: (DateTime date) {
                      setState(() {
                        _infodata.inf_date_start = new DateTime(date.year, date.month,date.day, _fromTime.hour, _fromTime.minute);
                        _trySetCanSave();

                      });
                    },
                    selectTime: (TimeOfDay time) {
                      setState(() {
                        _fromTime=time;
                        _infodata.inf_date_start = new DateTime(_infodata.inf_date_start.year, _infodata.inf_date_start.month,_infodata.inf_date_start.day, _fromTime.hour, _fromTime.minute);
                        _trySetCanSave();

                      });
                    },
                  ),
                ),
                new ListTile(
                  leading:
                      new Icon(Icons.date_range, color: theme.primaryColorDark),
                  title: new DateTimePicker(
                    labelText: 'Al',
                    selectedDate: _infodata.inf_date_end,
                    selectedTime: _toTime,
                    selectDate: (DateTime date) {
                      setState(() {
                        _infodata.inf_date_end = new DateTime(date.year, date.month,date.day, _toTime.hour, _toTime.minute);
                        _trySetCanSave();

                      });
                    },
                    selectTime: (TimeOfDay time) {
                      setState(() {
                        _toTime=time;
                        _infodata.inf_date_end = new DateTime(_infodata.inf_date_end.year, _infodata.inf_date_end.month,_infodata.inf_date_end.day, _toTime.hour, _toTime.minute);
                        _trySetCanSave();

                      });
                    },
                  ),
                ),

/*
                new InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Priorita',
                    hintText: 'Seleziona priorità',
                  ),
                  isEmpty: _activity == null,
                  child: new DropdownButton<String>(
                    value: _activity,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _activity = newValue;
                      });
                    },
                    items: _allActivities.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                  ),
                ),*/
              ].toList(),
            ),
          ),
        ));
  }
}
