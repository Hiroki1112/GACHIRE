import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:math' as math;

class Aori {
  Aori(this.aori, this.file);

  String aori;
  String file;
}

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
  VideoPlayerController _controller, _aorier, _bomber;
  double _volume = 0.2;
  bool _notend = true;

  int aorindex;

  var first_aories = [
    ['俺、この戦いが終わったら結婚するんだ', 'aori1-1.mp3'],
    ['始まったか・・・「伝説」が', 'aori1-1.mp3'],
    ['ここ〇研ゼミでやったところだ！', 'aori1-1.mp3'],
    ['ショウタイムだ', 'aori1-1.mp3'],
    ['負けるのはつまらない。だから僕は負けない。', 'aori1-1.mp3'],
    ['君を退屈から救いに来たんだ', 'aori1-1.mp3'],
    ['It’s now or never!', 'aori1-1.mp3'],
    ['いつやるの？今でしょ', 'aori1-1.mp3'],
    ['乗りかけた船には、ためらわず乗ってしまえ。', 'aori1-1.mp3'],
    ['お前の道を進め。人には勝手なこと言わせておけ。', 'aori1-1.mp3'],
    ['大きな目標だ。だからこそチャレンジするんだ。', 'aori1-1.mp3'],
    ['今できることを明日まで延ばすな', 'aori1-1.mp3'],
    ['全集中の呼吸！', 'aori1-1.mp3'],
    ['今日の成果は過去の努力の結果であり、未来はこれからの努力で決まる。', 'aori1-1.mp3'],
    ['進まざる者は必ず退き、退かざる者は必ず進む。', 'aori1-1.mp3'],
    ['難しいからやろうとしないのではない。やろうとしないから、難しくなるのだ。', 'aori1-1.mp3'],
    [
      'Step by step. I can’t see any other way of accomplishing anything.',
      'aori1-1.mp3'
    ],
    ['不可能を成し遂げるのは可能だ', 'aori1-1.mp3'],
    ['報われない努力もあるが、成功したものは皆須らく努力している', 'aori1-1.mp3'],
    ['高ければ高い壁の方が登った時気持ちいいもんな', 'aori1-19.mp3'],
  ];

  var second_aories = [
    ['・・・そろそろ動くか', 'aori2-1.mp3'],
    ['なかなかやるようだな', 'aori2-2.mp3'],
    ['お前の本気はその程度か？', 'aori2-3.mp3'],
    ['残像だ', 'aori2-4.mp3'],
    ['お前はどうしたい？返事はいらない', 'aori2-5.mp3'],
    ['踏んばれ！', 'aori2-6.mp3'],
    ['きつい？わかるなぁその気持ち。でもやり切った自分の顔がどれだけ美しいか確かめたくないか？', 'aori2-7.mp3'],
    ['やり切ったら気持ちよく眠れるだろうなぁ。', 'aori2-8.mp3'],
    ['人間は負けたら終わりではない。辞めたら終わりなのだ。', 'aori2-9.mp3'],
    ['もっとやれば、もっとできる。', 'aori2-10.mp3'],
    ['諦めたらそこで試合終了ですよ。', 'aori2-11.mp3'],
    ['自分と戦う時間が勝敗を分ける', 'aori2-12.mp3'],
    ['お前を笑うのは過去の自分だ', 'aori2-13.mp3'],
  ];

  var third_aories = [
    ['ここは俺に任せて先に行くんだ！！', 'aori3-1.mp3'],
    ['秒針は皆平等らしい', 'aori3-2.mp3'],
    ['勝てる・・・勝てるんだ・・・！', 'aori3-3.mp3'],
    ['最後まで諦めるな！', 'aori3-4.mp3'],
    ['遊びは終わりだ', 'aori3-5.mp3'],
    ['やったか？', 'aori3-6.mp3'],
    ['チェックメイトだ', 'aori3-7.mp3'],
    ['ラストスパートだ！', 'aori3-8.mp3'],
    ['勝利は目前だ', 'aori3-9.mp3'],
    ['逃げちゃだめだ。', 'aori3-10.mp3'],
    ['あきらめないことだ。一度あきらめると習慣になる', 'aori3-11.mp3'],
    ['止まるんじゃねぇぞ…', 'aori3-12.mp3'],
    ['諦める瞬間とは、君以外の誰かが成功する瞬間である。', 'aori3-13.mp3'],
  ];
// Map<曲名, ファイル名>
  Map<String, String> bgmlists = {
    '海': 'music1.mp3',
    '六月の遠雷': 'rokugatsunoenrai.mp3',
    'セビーリャの砦': 'sevillanotoride.mp3',
    'プラネット・ナイン': 'planetnine.mp3',
    '英雄の証': 'au.mp3',
    '白日': 'hakujitsu.mp3'
  };

  @override
  void initState() {
    super.initState();

    aorindex = random.nextInt(first_aories.length);
    _aori_text = first_aories[aorindex][0];

    //
    var _textTime = widget.params.time;
    var _textHour = _textTime.split("時間");
    var _textMin = _textHour[1].split("分");
    var _textSec = _textMin[1].split("秒");

    //_countdown => 秒数に直す(double型)
    _countdown = double.parse(_textHour[0]) * 3600 +
        double.parse(_textMin[0]) * 60 +
        double.parse(_textSec[0]);
    //5残り50%と10%の時間を
    _first_check = _countdown.toInt() ~/ 2;
    _second_check = _countdown.toInt() ~/ 10;

    _timer = Timer.periodic(
      Duration(milliseconds: 10),
      _onTimer,
    );

    // 煽り文を音声で流す
    // とりあえずaori1-1.mp3流す（後で煽り文と対応させる）
    _aorier = VideoPlayerController.asset('aori/${first_aories[0][1]}');
    _aorier.setVolume(_volume);
    // _aorier = VideoPlayerController.asset('aori/${first_aories[aorindex][1]}');
    _aorier.setLooping(false);
    _aorier.initialize().then((_) {
      setState(() {});
    });
    _aorier.play();

    _controller =
        VideoPlayerController.asset('bgm/${bgmlists[widget.params.bgm]}');
    _controller.setLooping(true);
    _controller.setVolume(_volume);
    _controller.initialize().then((_) {
      setState(() {});
    });

    _bomber = VideoPlayerController.asset('effects/bomb1.mp3');
    _bomber.setLooping(false);
    _bomber.setVolume(1.0);
    _bomber.initialize().then((_) {
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

  Container RestTimeWidget() {
    if (_countdown < 0.01) {
      return Container(
          child: Image(
        image: AssetImage('images/bakuen.gif'),
        fit: BoxFit.cover,
      ));
      ;
    } else {
      return Container(
          padding: EdgeInsets.all(15),
          child: Text(_time,
              style: TextStyle(
                fontSize: 70.0,
                fontFamily: 'IBMPlexMono',
              )));
    }
  }

//ここを書き換える
  void _onTimer(Timer timer) {
    if (_countdown < 0.01) {
      _aori_text = "よくやった"; // 終わったときの文
      _notend = false;
      _controller.dispose();
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

        /*_aorier =VideoPlayerController.asset('aori/${second_aories[aorindex][1]}');
        _aorier.setLooping(false);
        _aorier.initialize().then((_) {
          setState(() {});
        });
        _aorier.play();*/

        //1/10地点
      } else if (_countdown.toInt() == _second_check && secound_flag) {
        secound_flag = false;
        _controller.setPlaybackSpeed(1.5);
        setState(() {
          aorindex = random.nextInt(third_aories.length);
          _aori_text = third_aories[aorindex][0];
        });
        //煽り文を再生する。

        /*_aorier =
            VideoPlayerController.asset('aori/${third_aories[aorindex][1]}');
        _aorier.setLooping(false);
        _aorier.initialize().then((_) {
          setState(() {});
        });
        _aorier.play();*/

      }
      _countdown -= 0.01;
    }

    //_countdown(int) -> 12:34の文字列形式に変換する
    int _hour = _countdown.toInt() ~/ 3600;
    int _min = (_countdown.toInt() % 3600) ~/ 60;
    int _sec = _countdown.toInt() % 60;
    int _milli = ((_countdown - _countdown.toInt()) * 100).toInt();

    String _strCountdown =
        "${_hour.toString().padLeft(2, "0")}:${_min.toString().padLeft(2, "0")}:${_sec.toString().padLeft(2, "0")}.${_milli.toString().padLeft(2, "0")}";
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
              child: Text(
                "～${widget.params.target}の達成まで～",
                style: TextStyle(fontSize: 30),
              )),
          RestTimeWidget(),
          Container(
            padding: EdgeInsets.all(15),
            height: 100,
            child: Text("${_aori_text}", style: TextStyle(fontSize: 25)),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: ButtonTheme(
              minWidth: 120.0,
              height: 60.0,
              child: RaisedButton(
                elevation: 10,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("諦める", style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ])));
  }
}
