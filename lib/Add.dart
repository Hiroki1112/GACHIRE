import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';
import 'PickerDatas.dart';

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

  void _setBgm(String text) {
    setState(() => _bgm = text);
  }

  Container TimerWidget() {
    if (_time == "") {
      return Container(
        height: 0,
      );
    } else {
      return Container(
        padding: EdgeInsets.all(10),
        child: Text(_time, style: TextStyle(fontSize: 20)),
      );
    }
  }

  Container BGMWidget() {
    if (_bgm == "") {
      return Container(
        height: 0,
      );
    } else {
      return Container(
        padding: EdgeInsets.all(10),
        child: Text(_bgm, style: TextStyle(fontSize: 20)),
      );
    }
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
              maxLength: 20,
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
          TimerWidget(),
          Container(
            padding: EdgeInsets.all(10),
            width: 300.0,
            child: RaisedButton(
              child: Text('時間入力ボタン'),
              onPressed: () {
                showPickerArray(context);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text("BGMを選択してください", style: TextStyle(fontSize: 30)),
          ),
          BGMWidget(),
          Container(
            padding: EdgeInsets.all(10),
            width: 300.0,
            child: Container(
              padding: EdgeInsets.all(10),
              width: 300.0,
              child: RaisedButton(
                child: Text('BGM選択ボタン'),
                onPressed: () {
                  showBGMPicker(context);
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(30),
            child: ButtonTheme(
              minWidth: 150.0,
              height: 75.0,
              child: RaisedButton(
                elevation: 25,
                onPressed: () {
                  var returntexts = Map();
                  returntexts['target'] = _target;
                  returntexts['time'] = _time;
                  returntexts['bgm'] = _bgm;
                  Navigator.of(context).pop(returntexts);
                },
                child: Text("追加", style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ])));
  }

  showPickerArray(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(PickerData2),
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [3, 30, 0],
        title: Text("時間：分：秒で指定してください"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        cancel: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("cancel")),
        onConfirm: (Picker picker, List value) {
          //print(value.toString());
          //print(picker.getSelectedValues());

          _setTime(picker.getSelectedValues()[0] +
              "時間" +
              picker.getSelectedValues()[1] +
              "分" +
              picker.getSelectedValues()[2] +
              "秒");
        }).showDialog(context);
  }

  showBGMPicker(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(PickerBGM),
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [0],
        title: Text("リストから選択してください"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        cancel: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("cancel")),
        onConfirm: (Picker picker, List value) {
          //print(value.toString());
          //print(picker.getSelectedValues());

          _setBgm(picker.getSelectedValues()[0]);
        }).showDialog(context);
  }
}
