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
  double _countdown = 0.0;
  var _timer;
  var random = new math.Random();
  var _first_check, _second_check;
  bool first_flag = true;
  bool secound_flag = true;
  var _aori_text;
  VideoPlayerController _controller;

  int aorindex;
  List<String> aories = [
    "コーナーで差をつけろ",
    "僕は、努力しない自分は嫌いだ",
    "おのれの限界に\n気づいたつもりかい？",
    "Just Do it!!"
  ];

  List<String> first_aories = [
    '俺、この戦いが終わったら結婚するんだ',
    '始まったか・・・「伝説」が',
    'ここ〇研ゼミでやったところだ！',
    'ショウタイムだ',
    '負けるのはつまらない。だから僕は負けない。',
    '君を退屈から救いに来たんだ',
    'It’s now or never!',
    'いつやるの？今でしょ',
    '乗りかけた船には、ためらわず乗ってしまえ。',
    'お前の道を進め。人には勝手なこと言わせておけ。',
    '大きな目標だ。だからこそチャレンジするんだ。',
    '今できることを明日まで延ばすな',
    '全集中の呼吸！',
    '今日の成果は過去の努力の結果であり、未来はこれからの努力で決まる。',
    '進まざる者は必ず退き、退かざる者は必ず進む。',
    '難しいからやろうとしないのではない。やろうとしないから、難しくなるのだ。',
    'Step by step. I can’t see any other way of accomplishing anything.',
    '不可能を成し遂げるのは可能だ',
    '報われない努力もあるが、成功したものは皆須らく努力している',
    '高ければ高い壁の方が登った時気持ちいいもんな'
  ];

  List<String> second_aories = [
    '・・・そろそろ動くか',
    'なかなかやるようだな',
    'お前の本気はその程度か？',
    '残像だ',
    'お前はどうしたい？返事はいらない',
    '踏んばれ！',
    'きつい？わかるなぁその気持ち。でもやり切った自分の顔がどれだけ美しいか確かめたくないか？',
    'やり切ったら気持ちよく眠れるだろうなぁ。',
    '人間は負けたら終わりではない。辞めたら終わりなのだ。',
    'もっとやれば、もっとできる。',
    '諦めたらそこで試合終了ですよ。',
    '自分と戦う時間が勝敗を分ける',
    'お前を笑うのは過去の自分だ'
  ];

  List<String> third_aories = [
    'ここは俺に任せて先に行くんだ！！',
    '秒針は皆平等らしい',
    '勝てる・・・勝てるんだ・・・！',
    '最後まで諦めるな！',
    '遊びは終わりだ',
    'やったか？',
    'チェックメイトだ',
    'ラストスパートだ！',
    '勝利は目前だ',
    '逃げちゃだめだ。',
    'あきらめないことだ。一度あきらめると習慣になる',
    '止まるんじゃねぇぞ…',
    '諦めた瞬間とは、君以外の誰かが成功する瞬間である。'
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
    _aori_text = first_aories[aorindex];
    _countdown = double.parse(widget.params['time']);

    //5残り50%と10%の時間を
    _first_check = _countdown.toInt() ~/ 2;
    _second_check = _countdown.toInt() ~/ 10;

    _timer = Timer.periodic(
      Duration(milliseconds: 10),
      _onTimer,
    );
    // _controller = VideoPlayerController.asset(bgmlists[widget.params['bgm']]);
    _controller =
        VideoPlayerController.asset('assets/${bgmlists[widget.params['bgm']]}');
    _controller.setLooping(true);
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
    if (_countdown == 0.0) {
      _controller.dispose();
      timer.cancel();
    } else if (_countdown > 0) {
      if (_countdown.toInt() == _first_check && first_flag) {
        first_flag = false;
        setState(() {
          aorindex = random.nextInt(second_aories.length);
          _aori_text = second_aories[aorindex];
        });
      } else if (_countdown.toInt() == _second_check && secound_flag) {
        secound_flag = false;
        setState(() {
          aorindex = random.nextInt(third_aories.length);
          _aori_text = third_aories[aorindex];
        });
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
            child: Text("${_aori_text}", style: TextStyle(fontSize: 30)),
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
