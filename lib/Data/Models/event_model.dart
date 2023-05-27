// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  final String?id;
  String? title;//
  String? venue;//
  String? time;
  String? organizers;//
  String? link;//
  String? imageUrl;
  String? description;//
  String startTime;
  String endTime;
  Timestamp? date;

  Event({
    this.id,
    this.title,
    this.venue,
    this.time,
    this.organizers,
    this.link,
    this.imageUrl,
    this.description,
    this.date,
    required this.startTime,
    required this.endTime,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        title: json["title"],
        venue: json["venue"],
        time: json["time"],
        organizers: json["organizers"],
        link: json["link"],
        imageUrl: json["imageUrl"],
        description: json["description"],
        date: json["date"],
        startTime: json["startTime"],
        endTime: json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "venue": venue,
        "time": time,
        "organizers": organizers,
        "link": link,
        "imageUrl": imageUrl,
        "description": description,
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
      };
}
