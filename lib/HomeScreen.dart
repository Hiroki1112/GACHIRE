import 'package:flutter/material.dart';
import './Add.dart';
import './Clock.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GACHIRE"),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.done_outline_outlined,
                color: Colors.orangeAccent,
              ),
              title: Text(todoList[index]['target']),
              subtitle: Text(
                  "時間：${todoList[index]['time']} BGM：${todoList[index]['bgm']}"),
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
                  child: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    //削除処理

                    setState(() {
                      todoList.removeAt(index);
                    });
                  },
                  splashColor: Colors.red,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // *** 追加する部分 ***
        onPressed: () async {
          // "push"で新規画面に遷移
          // リスト追加画面から渡される値を受け取る
          final Map newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定
              return AddScreen();
            }),
          );
          if (newListText != null) {
            // キャンセルした場合は newListText が null となるので注意
            setState(() {
              // リスト追加
              todoList.add(newListText);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
