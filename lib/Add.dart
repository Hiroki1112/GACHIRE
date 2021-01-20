import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'PickerData.dart';
import './valModel.dart';

class AddScreen extends StatefulWidget {
  List<ValModel> data;
  @override
  AddScreen({this.data});
  _AddState createState() => _AddState();
}

class _AddState extends State<AddScreen> {
  VideoPlayerController _effecter;
  String _target = '';
  String _time = '';
  String _bgm = '';

  @override
  void initState() {
    super.initState();
    _effecter = VideoPlayerController.asset('effects/oh.mp3');
    _effecter.setLooping(false);
    _effecter.setVolume(1.0);
    _effecter.initialize().then((_) {
      setState(() {});
    });
  }

  void _setTarget(String text) {
    setState(() => _target = text);
  }

  void _setTime(String text) {
    setState(() => _time = text);
  }

  void _setBgm(String text) {
    setState(() => _bgm = text);
  }

  Future<void> _setValue(count) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // キーがあるかを確認
    if (!prefs.containsKey('DataList')) {
      List<ValModel> valList = [];
      valList.add(count);
      List<String> valtmp =
          valList.map((val) => json.encode(val.toJson())).toList();
      await prefs.setStringList('DataList', valtmp);
    } else {
      //既存のリストを読み込む
      List<ValModel> oldData = widget.data;
      oldData.add(count);
      List<String> valtmp =
          oldData.map((val) => json.encode(val.toJson())).toList();
      await prefs.setStringList('DataList', valtmp);
    }
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
        child: Text(_bgm, style: TextStyle(fontSize: 20, fontFamily: '')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("GACHIRE"), //leading: Container()
        ),
        body: SingleChildScrollView(
            child: Center(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(padding: EdgeInsets.only(top: 40)),
          Container(
            padding: EdgeInsets.all(10),
            child: Text("「使命」を定めよ", style: TextStyle(fontSize: 30)),
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
            child: Text("「刻」を定めよ", style: TextStyle(fontSize: 30)),
          ),
          TimerWidget(),
          Container(
            padding: EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width * 0.7,
            child: RaisedButton(
              child: Text('時間入力ボタン'),
              onPressed: () {
                showPickerArray(context);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text("「旋律」を定めよ", style: TextStyle(fontSize: 30)),
          ),
          BGMWidget(),
          Container(
            padding: EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width * 0.7,
            child: RaisedButton(
              child: Text('BGM選択ボタン'),
              onPressed: () {
                showBGMPicker(context);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width * 0.7,
            child: ButtonTheme(
              height: 55,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                elevation: 25,
                onPressed: () {
                  //var returntexts = Map();

                  if (_time == '') {
                    _time = '30分0秒';
                  }
                  if (_bgm == '') {
                    _bgm = '海';
                  }

                  ValModel returntexts =
                      ValModel(target: _target, time: _time, bgm: _bgm);
                  /*
                  returntexts['target'] = _target;
                  returntexts['time'] = _time;
                  returntexts['bgm'] = _bgm;
                  //Navigator.of(context).pop(returntexts);
                  */
                  _effecter.play();
                  _setValue(returntexts);
                  Navigator.of(context).pop(returntexts);
                },
                child: Text("追加", style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ]))));
  }

  showPickerArray(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(PickerData2),
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [30, 0],
        title: Text("分：秒で指定せよ"),
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
              "分" +
              picker.getSelectedValues()[1] +
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
        title: Text("リストから選択せよ"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        cancel: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("cancel")),
        onConfirm: (Picker picker, List value) {
          _setBgm(picker.getSelectedValues()[0]);
        }).showDialog(context);
  }
}
