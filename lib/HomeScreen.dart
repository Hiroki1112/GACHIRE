import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import './Add.dart';
import './Clock.dart';
import 'dart:convert';
import './valModel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ValModel> todoList = [];
  VideoPlayerController _effecter, _trasher;

  Future<String> _fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    // キーがあるかを確認
    if (!prefs.containsKey('DataList')) {
      //print("None!");
    } else {
      List<String> countData = prefs.getStringList('DataList');
      // String => Map
      print(countData);
      todoList =
          countData.map((val) => ValModel.fromJson(json.decode(val))).toList();
    }

    return Future.value("成功しました");
  }

  Future<String> _deleteData(index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    todoList.removeAt(index);

    List<void> valtmp =
        todoList.map((val) => json.encode(val.toJson())).toList();
    await prefs.setStringList('DataList', valtmp);
  }

  //初期化用関数
  @override
  void initState() {
    super.initState();
    _effecter = VideoPlayerController.asset('effects/33.mp3');
    _effecter.setLooping(false);
    _effecter.setVolume(1.0);
    _effecter.initialize();
    _trasher = VideoPlayerController.asset('effects/pop.mp3');
    _trasher.setLooping(false);
    _trasher.setVolume(1.0);
    _trasher.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GACHIRE"),
      ),
      body: Center(
          child: FutureBuilder(
              future: _fetchData(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.done_outline_outlined,
                          color: Colors.orangeAccent,
                        ),
                        title: Text(todoList[index].target),
                        subtitle: Text(
                            "時間：${todoList[index].time} \nBGM：${todoList[index].bgm}"),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              // 遷移先の画面としてリスト追加画面を指定
                              return Clock(params: todoList[index]);
                            }),
                          );
                        },
                        trailing: ButtonTheme(
                          minWidth: 30,
                          child: RaisedButton(
                            color: Colors.white,
                            elevation: 0,
                            child:
                                Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              //削除処理
                              _trasher.play();
                              setState(() {
                                _deleteData(index);
                              });
                            },
                            splashColor: Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                );
              })),
      floatingActionButton: FloatingActionButton(
        // *** 追加する部分 ***
        onPressed: () async {
          // "push"で新規画面に遷移
          // リスト追加画面から渡される値を受け取る
          _effecter.play();

          ValModel newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定
              return AddScreen(data: todoList);
            }),
          );
          if (newListText != null) {
            // キャンセルした場合は newListText が null となるので注意
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
