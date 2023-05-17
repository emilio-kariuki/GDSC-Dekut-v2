// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  String? name;
  String? id;
  String? message;
  int? time;
  DateTime ?timestamp;

  Message({
    this.name,
    this.id,
    this.message,
    this.time,
    this.timestamp
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        name: json["name"],
        id: json["id"],
        message: json["message"],
        time: json["time"],
        timestamp: DateTime.parse(json["timestamp"])
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "message": message,
        "time": time,
        "timestamp": timestamp!.toIso8601String()
      };
}
