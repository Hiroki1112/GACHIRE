import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  static String id = 'add_screen';
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<AddScreen> {
  String _target = '';
  String _time = '';
  String _bgm = '';

  void _setTarget(String text) {
    setState(() => _target = text);
  }

  void _setTime(String text) {
    setState(() => _time = text);
  }

  void _setBgm(text) {
    setState(() => _bgm = text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("GACHIRE"), //leading: Container()
        ),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Text("目標を入力してください", style: TextStyle(fontSize: 30)),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: 300.0,
            child: TextField(
              enabled: true,
              // 入力数
              maxLength: 10,
              maxLengthEnforced: false,
              style: TextStyle(color: Colors.blue),
              maxLines: 1,
              onChanged: _setTarget,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text("時間を入力してください", style: TextStyle(fontSize: 30)),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: 300.0,
            child: TextField(
              enabled: true,
              // 入力数
              maxLength: 10,
              maxLengthEnforced: false,
              style: TextStyle(color: Colors.blue),
              maxLines: 1,
              onChanged: _setTime,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text("BGMを選択してください"),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: 300.0,
            child: TextField(
              enabled: true,
              // 入力数
              maxLength: 10,
              maxLengthEnforced: false,
              style: TextStyle(color: Colors.blue),
              maxLines: 1,
              onChanged: _setBgm,
            ),
          ),
          Container(
            padding: EdgeInsets.all(30),
            child: ButtonTheme(
              minWidth: 200.0,
              height: 100.0,
              child: RaisedButton(
                elevation: 5,
                onPressed: () {
                  var returntexts = Map();
                  returntexts['target'] = _target;
                  returntexts['time'] = _time;
                  returntexts['bgm'] = _bgm;
                  Navigator.of(context).pop(returntexts);
                },
                child: Text("追加"),
              ),
            ),
          ),
        ])));
  }
}
