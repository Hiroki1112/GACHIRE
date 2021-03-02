import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:math' as math;
import '../const/appreciations.dart';
import '../const/aori.dart';
import '../const/musicList.dart';

class Clock extends StatefulWidget {
  final params;
  @override
  //引数の受け取り

  Clock({this.params});
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String _time = '';
  double _countdown = 0.0;
  var _timer;
  var random = new math.Random();
  var _first_check, _second_check;
  bool first_flag = true;
  bool secound_flag = true;
  var _aori_text;

  VideoPlayerController _controller, _aorier, _bomber, _effecter, _heartBeart;

  double _volume = 0.2;
  bool _notend = true;
  var _buttonText = '諦める';

  int aorindex;

  void playEffects(String filename) {
    print('effects/${filename}');
    VideoPlayerController _eff =
        VideoPlayerController.asset('effects/${filename}');
    _eff.setLooping(false);
    _eff.setVolume(1.0);
    _eff.initialize().then((_) {
      setState(() {});
    });
    _eff.play();
    _eff.dispose();
  }

  @override
  void initState() {
    super.initState();

    aorindex = random.nextInt(first_aories.length);
    _aori_text = first_aories[aorindex][0];

    var _textTime = widget.params.time;
    var _textMin = _textTime.split("分");
    var _textSec = _textMin[1].split("秒");

    //_countdown => 秒数に直す(double型)
    _countdown = double.parse(_textMin[0]) * 60 + double.parse(_textSec[0]);
    //5残り50%と10%の時間を
    _first_check = _countdown.toInt() ~/ 2;
    _second_check = _countdown.toInt() ~/ 10;

    //音声オブジェクトを作成

    _timer = Timer.periodic(
      Duration(milliseconds: 10),
      _onTimer,
    );

    _effecter = VideoPlayerController.asset('effects/33.mp3');
    _effecter.setLooping(false);
    _effecter.setVolume(1.0);
    _effecter.initialize();

    // 煽り文を音声で流す
    // とりあえずaori1-1.mp3流す（後で煽り文と対応させる）
    _aorier = VideoPlayerController.asset('aori/${first_aories[aorindex][1]}');
    _aorier.setVolume(_volume);
    _aorier.setLooping(false);
    _aorier.initialize();
    _aorier.play();

    _controller =
        VideoPlayerController.asset('bgm/${bgmlists[widget.params.bgm]}');
    _controller.setLooping(true);
    _controller.setVolume(_volume);
    _controller.initialize();

    _bomber = VideoPlayerController.asset('effects/bomb1.mp3');
    _bomber.setLooping(false);
    _bomber.setVolume(1.0);
    _bomber.initialize();

    _heartBeart = VideoPlayerController.asset('effects/Heart_Beat01-1L.mp3');
    _heartBeart.setLooping(true);
    _heartBeart.setVolume(1.0);
    _heartBeart.initialize();

    _controller.play();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    // 破棄される時に停止する.
    _controller.dispose();
    _timer.cancel();
    _bomber.dispose();
    _aorier.dispose();
    _heartBeart.dispose();
  }

  Container TimeWidget() {
    if (_countdown < 0.01) {
      return Container(
          child: Image(
        image: AssetImage('images/bakuen.gif'),
        fit: BoxFit.cover,
      ));
    } else {
      return Container(
          padding: EdgeInsets.all(15),
          child: Text(_time,
              style: TextStyle(
                fontSize: 80.0,
                fontFamily: 'IBMPlexMono',
              )));
    }
  }

//ここを書き換える
  void _onTimer(Timer timer) {
    if (_countdown < 0.01) {
      _buttonText = '終わりを告げる';
      _aori_text =
          APPRECIATIONS[random.nextInt(APPRECIATIONS.length)]; // 終わったときの文
      _notend = false;
      _controller.pause();
      timer.cancel();
      _bomber.play();
    } else if (_countdown > 0) {
      // 1/2地点
      if (_countdown.toInt() == _first_check && first_flag) {
        first_flag = false;
        _controller.setPlaybackSpeed(1.2);
        setState(() {
          aorindex = random.nextInt(second_aories.length);
          _aori_text = second_aories[aorindex][0];
        });
        //煽り文を再生する。

        _aorier =
            VideoPlayerController.asset('aori/${second_aories[aorindex][1]}');
        _aorier.setLooping(false);
        _aorier.initialize().then((_) {
          setState(() {});
        });
        _aorier.play();

        //1/10地点
      } else if (_countdown.toInt() == _second_check && secound_flag) {
        secound_flag = false;
        _controller.setPlaybackSpeed(1.5);
        setState(() {
          aorindex = random.nextInt(third_aories.length);
          _aori_text = third_aories[aorindex][0];
        });
        //煽り文を再生する。

        _aorier =
            VideoPlayerController.asset('aori/${third_aories[aorindex][1]}');
        _aorier.setLooping(false);
        _aorier.initialize().then((_) {
          setState(() {});
        });
        _aorier.play();
      }
      _countdown -= 0.01;
    }

    //_countdown(int) -> 12:34の文字列形式に変換する
    int _min = (_countdown.toInt() % 3600) ~/ 60;
    int _sec = _countdown.toInt() % 60;
    int _milli = ((_countdown - _countdown.toInt()) * 100).toInt();

    String _strCountdown =
        "${_min.toString().padLeft(2, "0")}:${_sec.toString().padLeft(2, "0")}.${_milli.toString().padLeft(2, "0")}";
    setState(() => _time = _strCountdown);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("GACHIRE"), leading: Container()),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.volume_mute),
                Slider(
                  value: _volume,
                  min: 0,
                  max: 1,
                  divisions: 10,
                  label: (_volume * 100).toString(),
                  onChanged: (double value) {
                    setState(() {
                      if (_notend) {
                        _volume = value;
                        _controller.setVolume(_volume);
                      }
                    });
                  },
                ),
                Icon(Icons.volume_up_rounded),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  Text(
                    "†${widget.params.target}†",
                    style: TextStyle(fontSize: 30),
                  ),
                  Text("を完遂し世界を救え")
                ],
              )),
          TimeWidget(),
          Container(
            padding: EdgeInsets.all(15),
            height: 100,
            child: Text("${_aori_text}", style: TextStyle(fontSize: 25)),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: ButtonTheme(
                  minWidth: 120.0,
                  height: 60.0,
                  child: RaisedButton(
                    elevation: 10,
                    onPressed: () async {
                      if (_notend) {
                        _heartBeart.play();
                        var res = await showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text("確認"),
                              content: Text("諦めたらそこで試合終了ですよ？"),
                              actions: <Widget>[
                                // ボタン領域
                                FlatButton(
                                  child: Text("諦めない"),
                                  onPressed: () {
                                    playEffects("Glocken02-1Low-Long.mp3");
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                                FlatButton(
                                    child: Text("諦める",
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      playEffects("akirameru.mp3");
                                      Navigator.of(context).pop(true);
                                    }),
                              ],
                            );
                          },
                        );
                        _heartBeart.pause();
                        if (res != null && res) Navigator.of(context).pop();
                      } else
                        Navigator.of(context).pop();
                    },
                    child: Text(_buttonText, style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: ButtonTheme(
                  minWidth: 120.0,
                  height: 60.0,
                  child: RaisedButton(
                    elevation: 10,
                    onPressed: !_notend
                        ? null
                        : () async {
                            var res = await showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text("確認"),
                                  content: Text("目標を達成しましたか？"),
                                  actions: <Widget>[
                                    // ボタン領域
                                    FlatButton(
                                      child: Text("まだ..."),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                    ),
                                    FlatButton(
                                        child: Text("達成！"),
                                        onPressed: () {
                                          setState(() {
                                            _countdown = 0.04;
                                          });
                                          Navigator.of(context).pop(true);
                                        }),
                                  ],
                                );
                              },
                            );
                          },
                    child: Text("達成", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          )
        ])));
  }
}
