class ValModel {
  String target;
  String time;
  String bgm;

  ValModel({this.target, this.time, this.bgm});

  Map toJson() => {
        'target': target,
        'time': time,
        'bgm': bgm,
      };

  ValModel.fromJson(Map json)
      : target = json['target'],
        time = json['time'],
        bgm = json['bgm'];
}
