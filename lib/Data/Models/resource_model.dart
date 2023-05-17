// To parse this JSON data, do
//
//     final resource = resourceFromJson(jsonString);

import 'dart:convert';

Resource resourceFromJson(String str) => Resource.fromJson(json.decode(str));

String resourceToJson(Resource data) => json.encode(data.toJson());

class Resource {
    String? title;
    String? link;
    String? description;
    String? imageUrl;

    Resource({
        this.title,
        this.link,
        this.description,
        this.imageUrl,
    });

    factory Resource.fromJson(Map<String, dynamic> json) => Resource(
        title: json["title"],
        link: json["link"],
        description: json["description"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "link": link,
        "description": description,
        "imageUrl": imageUrl,
    };
}
