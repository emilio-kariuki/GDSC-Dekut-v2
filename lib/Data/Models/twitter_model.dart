// To parse this JSON data, do
//
//     final twitterModel = twitterModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<TwitterModel> twitterModelFromJson(String str) => List<TwitterModel>.from(json.decode(str).map((x) => TwitterModel.fromJson(x)));

String twitterModelToJson(List<TwitterModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TwitterModel {
    String? title;
    String? link;
    String? image;
   
    Timestamp startTime;
    Timestamp endTime;

    TwitterModel({
        this.title,
        this.link,
        this.image,
        required this.startTime,
        required this.endTime,
    });

    factory TwitterModel.fromJson(Map<String, dynamic> json) => TwitterModel(
        title: json["title"],
        link: json["link"],
        image: json["image"],
        startTime: json["startTime"],
        endTime: json["endTime"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "link": link,
        "image": image,
        "startTime": startTime,
        "endTime": endTime,
    };
}
