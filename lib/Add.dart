import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';
import 'Clock.dart';

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
        selecteds: [3, 0, 0],
        title: Text("Please Select"),
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
        title: Text("Please Select"),
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

// var hour = new List<int>.generate(23, (i) => i + 1);
// var min = new List<int>.generate(59, (i) => i + 1);
// var sec = new List<int>.generate(59, (i) => i + 1);

const PickerData2 = '''
[
    [0, 1, 2, 3,4,5,6,7,8,9,10,11,12,13,14],
    [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59],
    [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
]
    ''';

const PickerBGM = '''
[
  ["白日","海","英雄の証","六月の遠雷","セビーリャの砦","プラネット・ナイン"]
]
    ''';
