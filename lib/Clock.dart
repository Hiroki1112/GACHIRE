import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:math' as math;

class Clock extends StatefulWidget {
  final params;
  @override
  //引数の受け取り

  Clock({this.params});
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String _time = '';
  int _countdown = 0;
  var _timer;
  var random = new math.Random();
  VideoPlayerController _controller;

  int aorindex;
  List<String> aories = [
    "コーナーで差をつけろ",
    "僕は、努力しない自分は嫌いだ",
    "おのれの限界に\n気づいたつもりかい？",
    "Just Do it!!"
  ];

  @override
  void initState() {
    super.initState();
    aorindex = random.nextInt(aories.length);
    _countdown = int.parse(widget.params['time']);
    _timer = Timer.periodic(
      Duration(seconds: 1),
      _onTimer,
    );
    _controller = VideoPlayerController.asset('assets/music1.mp3');
    _controller.initialize().then((_) {
      setState(() {});
    });
    _controller.play();
  }

  @override
  void dispose() {
    // 破棄される時に停止する.
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  //ここを書き換える
  void _onTimer(Timer timer) {
    if (_countdown == 0) {
      timer.cancel();
    } else {
      _countdown--;
    }
    //_countdown(int) -> 12:34の文字列形式に変換する
    int _hour = _countdown ~/ 3600;
    int _min = (_countdown % 3600) ~/ 60;
    int _sec = _countdown % 60;

    String _strCountdown =
        "${_hour.toString().padLeft(2, "0")}:${_min.toString().padLeft(2, "0")}:${_sec.toString().padLeft(2, "0")}";
    setState(() => _time = _strCountdown);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("GACHIRE"), leading: Container()),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "～${widget.params['target']}の達成まで～",
                style: TextStyle(fontSize: 30),
              )),
          Container(
              child: Text(_time,
                  style: TextStyle(
                    fontSize: 90.0,
                    fontFamily: 'IBMPlexMono',
                  ))),
          Container(
            padding: EdgeInsets.all(25),
            child: Text("${aories[aorindex]}", style: TextStyle(fontSize: 30)),
          ),
          Container(
            padding: EdgeInsets.all(30),
            child: ButtonTheme(
              minWidth: 200.0,
              height: 100.0,
              child: RaisedButton(
                elevation: 5,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("諦める"),
              ),
            ),
          ),
        ])));
  }
}
