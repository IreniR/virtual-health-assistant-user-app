import 'dart:convert';

class EventModel {
  final String title;
  final String id;
  final String desc;
  final DateTime date;
  final String userID; // link events w/ user
  final DateTime timeOfDay;

  EventModel(
      {this.title, this.id, this.desc, this.date, this.userID, this.timeOfDay});

  EventModel copyWith(
      {String title,
      String id,
      String desc,
      DateTime date,
      String userID,
      DateTime timeOfDay}) {
    return EventModel(
      title: title ?? this.title,
      id: id ?? this.id,
      desc: desc ?? this.desc,
      date: date ?? this.date,
      userID: userID ?? this.userID,
      timeOfDay: timeOfDay ?? this.timeOfDay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'desc': desc,
      'date': date.millisecondsSinceEpoch,
      'userId': userID,
      'timeOfDay': timeOfDay,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return EventModel(
      title: map['title'],
      id: map['id'],
      desc: map['desc'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      userID: map['userId'],
      timeOfDay: DateTime.fromMillisecondsSinceEpoch(map['timeOfDay']),
    );
  }

  factory EventModel.fromDS(String id, Map<String, dynamic> data) {
    if (data == null) return null;

    return EventModel(
      title: data['title'],
      id: id,
      desc: data['desc'],
      date: DateTime.fromMillisecondsSinceEpoch(data['date']),
      userID: data['user_id'],
      timeOfDay: DateTime.fromMillisecondsSinceEpoch(data['timeOfDay']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppEvent(title: $title, id: $id, description: $desc, date: $date, userId: $userID, timeOfDay: $timeOfDay)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is EventModel &&
        o.title == title &&
        o.id == id &&
        o.desc == desc &&
        o.date == date &&
        o.userID == userID &&
        o.timeOfDay == timeOfDay;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        id.hashCode ^
        desc.hashCode ^
        date.hashCode ^
        userID.hashCode ^
        timeOfDay.hashCode;
  }
}
