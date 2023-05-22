// To parse this JSON data, do
//
//     final groupsModel = groupsModelFromJson(jsonString);

import 'dart:convert';

List<GroupsModel> groupsModelFromJson(String str) => List<GroupsModel>.from(json.decode(str).map((x) => GroupsModel.fromJson(x)));

String groupsModelToJson(List<GroupsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupsModel {
    String? title;
    String? link;
    String? imageUrl;
    String? description;

    GroupsModel({
        this.title,
        this.link,
        this.imageUrl,
        this.description,
    });

    factory GroupsModel.fromJson(Map<String, dynamic> json) => GroupsModel(
        title: json["title"],
        link: json["link"],
        imageUrl: json["imageUrl"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "link": link,
        "imageUrl": imageUrl,
        "description": description,
    };
}
