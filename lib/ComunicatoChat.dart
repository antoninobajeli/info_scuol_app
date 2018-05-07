import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:info_scuol_app/model/IsaTutenze.dart';
import 'model/Info.dart';
import 'package:flutter/cupertino.dart';

import 'model/RequestEnvelop.dart';
import 'model/InfoChatResp.dart';
import 'model/InfoChat.dart';
import 'dart:convert';
import 'package:info_scuol_app/util/Network.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'model/InfoUteAdesione.dart';

/*
class ComunicatoChat extends StatefulWidget {
  ComunicatoChat({Key key, this.info}) : super(key: key);

  static const String routeName = "/ComunicatoChat";

  final Info info;

  @override
  _ComunicatoChatState createState() => new _ComunicatoChatState();
}

/// // 1. After the page has been created, register it with the app routes
/// routes: <String, WidgetBuilder>{
///   ComunicatoChat.routeName: (BuildContext context) => new ComunicatoChat(title: "ComunicatoChat"),
/// },
///
/// // 2. Then this could be used to navigate to the page.
/// Navigator.pushNamed(context, ComunicatoChat.routeName);
///

class _ComunicatoChatState extends State<ComunicatoChat> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.info.inf_titolo),
      ),
      body: new Container(
        ,

      ),



      floatingActionButton: new FloatingActionButton(
        onPressed: _onFloatingActionButtonPressed,
        tooltip: 'Add',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _onFloatingActionButtonPressed() {
  }
}
*/

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendlychat",
      theme: defaultTargetPlatform == TargetPlatform.iOS //new
          ? kIOSTheme //new
          : kDefaultTheme, //new
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key, this.user, this.info}) : super(key: key);

  static const String routeName = "/ComunicatoChat";

  final Info info; //modified
  final IsaTutenze user; //modified
  @override //new
  State createState() => new ChatScreenState(); //new
}

// Add the ChatScreenState class definition in main.dart.

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];

  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  int _isAgreeng = 2;

  @override
  initState() {
    // TODO: implement initState
/*
    for(int i=0;i<100;i++){
      ChatMessage message = new ChatMessage(
          text: "messaggio ${i}",
          animationController: null,
          isReceived: true
      );
      _messages.insert(0, message);
    }*/
    _getInfoChatList();
    super.initState();
  }

  @override
  void dispose() {
    //new
    for (ChatMessage message in _messages) {
      if (message.animationController!=null)
           message.animationController.dispose(); //new
    }
    super.dispose(); //new
  } //new

  @override
  Widget build(BuildContext context) {
    _name = widget.user.gen_nome;
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Chat per:" + widget.info.inf_titolo),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
      body: new Container(
          //modified
          child: new Column(
            //modified
            children: <Widget>[
              new Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildSubjectDetails(),
              ),
              new Divider(height: 10.0),
              new Flexible(
                child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS //new
              ? new BoxDecoration(
                  //new
                  border: new Border(
                    //new
                    top: new BorderSide(color: Colors.grey[200]), //new
                  ), //new
                ) //new
              : null), //modified
    );
  }

  Widget _buildSubjectDetails() {
    Widget titleSection = new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(widget.info.inf_titolo,
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                new Text('Si accettano adesioni- data scadenza ${widget.info.inf_date_end}',
                  style: new TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          new Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            new Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              /*new Icon(
                Icons.star,
                color: Colors.red[500],
              ),*/
              new ImageIcon(new AssetImage("assets/ok_mood.png"), color: Colors.green[500]),
              new Text('5'),
            ]),
            new Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              /*new Icon(
                Icons.star,
                color: Colors.red[500],
              ),*/
              new ImageIcon(new AssetImage("assets/thinking_mood.png"), color: Colors.yellow[800]),
              new Text('11'),
            ]),
            new Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              /*new Icon(
                Icons.star,
                color: Colors.red[500],
              ),*/
              new ImageIcon(new AssetImage("assets/ko_mood.png"), color: Colors.red[700]),
              new Text('8'),
            ]),

          ]),
        ],
      ),
    );

    Column buildButtonColumn(IconData icon, String iconAssetSrc, String label,String opType) {
      Color color = Theme.of(context).primaryColorDark;

      return new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new IconButton(icon: iconAssetSrc != null
              ? new ImageIcon(new AssetImage(iconAssetSrc), color: color)
              : new Icon(icon, color: color),
              onPressed:  () => _handleFunction()
                  ),

          new Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }


    InfoUteAdesione infoAdesioneObj= new InfoUteAdesione();
    infoAdesioneObj.ade_inf_id= widget.info.inf_id;
    infoAdesioneObj.ade_id= widget.info.ade_id;
    infoAdesioneObj.ade_scelta= widget.info.ade_scelta;
    infoAdesioneObj.ade_tut_id= widget.user.gen_id;

    Widget buttonSection = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.info, null, 'INFO',null),
          //buildButtonColumn(null, "assets/ko_mood.png", 'ADERISCI?',null),
          new SceltaAdesioneWidget(adesione: infoAdesioneObj),
          buildButtonColumn(Icons.share, null, 'CONDIVIDI',null),
        ],
      ),
    );

    Widget textSection = new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Text(
        widget.info.inf_descr,
        softWrap: true,
      ),
    );

    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Column(
          children: <Widget>[
            titleSection,
            buttonSection,
            /*new Image.asset(
              'assets/lake.jpg',
              width: 600.0,
              height: 120.0,
              fit: BoxFit.cover,
            ),*/
            /*new Image.network(
  'https://www.vacanzesiciliane.net/wp-content/uploads/nicosia.jpg', width: 600.0,
              height: 120.0,
              fit: BoxFit.cover,),*/
            new CachedNetworkImage(
              placeholder: new CircularProgressIndicator(),
              imageUrl:
              'https://www.vacanzesiciliane.net/wp-content/uploads/nicosia.jpg',width: 600.0,
              height: 120.0,
              fit: BoxFit.cover,
            ),
            textSection
          ],
        ));
  }






  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  //new
                  setState(() {
                    //new
                    _isComposing = text.length > 0; //new
                  }); //new
                }, //new
                onSubmitted: _handleSubmitMex,
                decoration: new InputDecoration.collapsed(
                    hintText: "Invia un messaggio"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? //modified
                  new CupertinoButton(
                      //new
                      child: new Text("Invia"), //new
                      onPressed: _isComposing //new
                          ? () => _handleSubmitMex(_textController.text) //new
                          : null,
                    )
                  : //new
                  new IconButton(
                      //modified
                      icon: new Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmitMex(_textController.text)
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }




  _getInfoChatList() async {
    RequestEnvelop envelop = new RequestEnvelop();
    envelop.ute_id = widget.user.gen_id;
    envelop.inf_id = widget.info.inf_id;
    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData, 'getInfoChats');
    if (!mounted) return;

    setState(() {
      //sending = false;
      InfoChatResp i = new InfoChatResp.fromJson(json.decode(resultData));
      List<InfoChat> _received = i.response;

      for (final mex in _received) {
        ChatMessage message = new ChatMessage(
            sender: mex.infcha_gen_name,
            text: mex.infcha_mex,
            animationController: null,
            isReceived: mex.infcha_gen_id==widget.user.gen_id?false:true);
        _messages.insert(0, message);
      }

      //widget.onChangedUser(_user);
    });
  }

  void _handleFunction(){}

  void  _handleSubmitMex(String text) async{
    _textController.clear();
    setState(() {
      //new
      _isComposing = false; //new
    }); //new
    ChatMessage message = new ChatMessage(
      sender: "Io",
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
      isAnimation: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();


    RequestEnvelop envelop = new RequestEnvelop();
    envelop.ute_id = widget.user.gen_id;
    envelop.inf_id = widget.info.inf_id;
    envelop.infcha_mex = text;
    String reqData = json.encode(envelop.toJson());


    Network n = new Network();
    var resultData = await n.getDataTask(reqData, 'setInfoChatMex');
    print(resultData);
  }


}

String _name = "";




/*
----------------------------------     MESSAGGIO
 */
// Scelta

class SceltaAdesioneWidget extends StatefulWidget {
  SceltaAdesioneWidget({this.adesione});
  final InfoUteAdesione adesione;
  @override //new
  State createState() => new _SceltaAdesioneWidgetState(); //new
}


class _SceltaAdesioneWidgetState extends State<SceltaAdesioneWidget> {
  int _isAgreeng;
  Color coloreSi;
  Color coloreNo;
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _isAgreeng=widget.adesione.ade_scelta;
    switch (_isAgreeng){
      case 0: coloreNo=Colors.red; coloreSi=Colors.grey;break;
      case 1: coloreNo=Colors.grey; coloreSi=Colors.teal;break;
      case 2: coloreNo=Colors.grey; coloreSi=Colors.grey;break;
    }
  }


  Column buildButtonColumn(IconData icon, String iconAssetSrc, String label,int opVal,Color colore) {
    Color color = Theme.of(context).primaryColorDark;

    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new IconButton(icon: iconAssetSrc != null
            ? new ImageIcon(new AssetImage(iconAssetSrc), color: colore)
            : new Icon(icon, color: color),
            onPressed:  () => _handleSubmitAgree(opVal)
        ),

        new Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: new Text(
            label,
            style: new TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmitAgree(int agree) async{

    setState(() {
      //new
      _isAgreeng= (agree>2) ?0 :agree; //new
      widget.adesione.ade_scelta=_isAgreeng;
      switch (_isAgreeng){
        case 0: coloreNo=Colors.red; coloreSi=Colors.grey;break;
        case 1: coloreNo=Colors.grey; coloreSi=Colors.teal;break;
        case 2: coloreNo=Colors.grey; coloreSi=Colors.grey;break;
      }

    }); //new


    RequestEnvelop envelop = new RequestEnvelop();
    envelop.infoUteAdesione=widget.adesione;
    String reqData = json.encode(envelop.toJson());

    Network n = new Network();
    var resultData = await n.getDataTask(reqData, 'setInfoUteAdesione');

  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(null, "assets/ko_mood.png", 'NO',0,coloreNo),
          buildButtonColumn(null, "assets/ok_mood.png", 'SI',1,coloreSi),
        ],
      ),
    );
  }
}







/*
----------------------------------     MESSAGGIO
 */
// Modify the build() method for the ChatMessage class as follows.
class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.text,
      this.sender,
      this.animationController,
      this.isReceived = false,
      this.isAnimation = false
      });

  final bool isReceived;
  final String text;
  final String sender;
  final bool isAnimation;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    Widget messageWidget;

    Widget senderMmxContainer=new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            //new
            child: new Column(
              //modified
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text(sender,
                    style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                ),
              ],
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text( (_name!=null)?_name[0]:"NoName")),
          ),
        ],
      ),
    ); //new

    if (isReceived) {
      messageWidget = new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(sender[0])),
            ),
            new Expanded(
              //new
              child: new Column(
                //modified
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(sender, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      if (isAnimation) {
        messageWidget = new SizeTransition(
            sizeFactor: new CurvedAnimation(
                parent: animationController, curve: Curves.easeOut),
            axisAlignment: 0.0,
            child: senderMmxContainer
        );
      }else{
        messageWidget = senderMmxContainer;
      }
    }

    return messageWidget;
  }





}











