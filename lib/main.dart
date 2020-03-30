import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final ThemeData kIOTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);
final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

void main() => runApp(FriendlyChat());

class FriendlyChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Friendlychat",
        home: ChatScreen(),
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOTheme
            : kDefaultTheme);
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Friendlychat"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                  child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              )),
              new Divider(
                height: 1.0,
              ),
              new Container(
                decoration: new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
        ));
  }

  void _handleSubmitted(String text) {
    _textEditingController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
          duration: new Duration(milliseconds: 2000), vsync: this),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
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
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                controller: _textEditingController,
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              )),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? new CupertinoButton(
                        child: new Text("Send"),
                        onPressed: _isComposing
                            ? () =>
                                _handleSubmitted(_textEditingController.text)
                            : null,
                      )
                    : new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: _isComposing
                            ? () =>
                                _handleSubmitted(_textEditingController.text)
                            : null,
                      ),
              )
            ],
          ),
        ));
  }

  /* it is a good practice to free up your animation controllers to free
  * up your resources when they are no longer needed.
  * */
  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  final AnimationController animationController;
  final String text;
  final String _name = "Yvon";

  ChatMessage({this.text, this.animationController});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeInOutCirc),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                child: new Text(_name[0]),
              ),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    _name,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
