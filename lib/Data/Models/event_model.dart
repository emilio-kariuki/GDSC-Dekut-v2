// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
    String? title;
    String? venue;
    String? time;
    String? organizers;
    String? link;
    String? imageUrl;
    String? description;
    String? portfolio;
    String? date;

    Event({
        this.title,
        this.venue,
        this.time,
        this.organizers,
        this.link,
        this.imageUrl,
        this.description,
        this.portfolio,
        this.date,
    });

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        title: json["title"],
        venue: json["venue"],
        time: json["time"],
        organizers: json["organizers"],
        link: json["link"],
        imageUrl: json["imageUrl"],
        description: json["description"],
        portfolio: json["portfolio"],
        date: json["date"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "venue": venue,
        "time": time,
        "organizers": organizers,
        "link": link,
        "imageUrl": imageUrl,
        "description": description,
        "portfolio": portfolio,
        "date": date,
    };
}
