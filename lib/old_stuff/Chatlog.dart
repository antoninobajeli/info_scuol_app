import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:info_scuol_app/util/Network.dart';
import 'package:info_scuol_app/model/RequestEnvelop.dart';
import 'package:info_scuol_app/model/ResponseEnvelop.dart';
import 'package:info_scuol_app/model/IsaTutenze.dart';

import 'dart:convert';



import 'package:flutter/material.dart';
/*

typedef void HandleAuth(AngelAuthResult auth);

class ChatLogin extends StatefulWidget {
  final Angel restApp;
  final HandleAuth handleAuth;

  ChatLogin(this.restApp, this.handleAuth);

  @override
  State createState() => new _ChatLoginState(restApp, handleAuth);
}


class _ChatLoginState extends State<ChatLogin> {
  final Angel restApp;
  final HandleAuth handleAuth;
  String username, password;
  bool sending = false;

  _ChatLoginState(this.restApp, this.handleAuth);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Form(
        child: new Column(
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(labelText: 'Username'),
              onChanged: (String str) => setState(() => username = str),
            ),
            new TextField(
              decoration: new InputDecoration(labelText: 'Password'),
              onChanged: (String str) => setState(() => password = str),
            ),
            sending
                ? new CircularProgressIndicator()
                : new RaisedButton(
              onPressed: () {
                setState(() => sending = true);
                restApp.authenticate(type: 'local', credentials: {
                  'username': username,
                  'password': password
                }).then((auth) {
                  handleAuth(auth);
                }).catchError((e) {
                  showDialog(
                      context: context,
                      child: new SimpleDialog(
                        title: new Text('Login Error: $e'),
                      ));
                }).whenComplete(() {
                  setState(() => sending = false);
                });
              },
              color: Theme.of(context).primaryColor,
              highlightColor: Theme.of(context).highlightColor,
              child: new Text(
                'SUBMIT',
                style: new TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

*/