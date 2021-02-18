// To parse this JSON data, do
//
//     final busSchedule = busScheduleFromJson(jsonString);

import 'dart:convert';

List<BusSchedule> busScheduleFromJson(String str) => List<BusSchedule>.from(json.decode(str).map((x) => BusSchedule.fromJson(x)));

String busScheduleToJson(List<BusSchedule> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusSchedule {
    String start;
    String end;
    List<String> route;
    List<List<String>> schedule;
    bool gowork;
    bool holiday;
    bool bookmark;

    BusSchedule({
        this.start,
        this.end,
        this.route,
        this.schedule,
        this.gowork,
        this.holiday,
        this.bookmark,
    });

    factory BusSchedule.fromJson(Map<String, dynamic> json) => BusSchedule(
        start: json["start"],
        end: json["end"],
        route: List<String>.from(json["route"].map((x) => x)),
        schedule: List<List<String>>.from(json["schedule"].map((x) => List<String>.from(x.map((x) => x)))),
        gowork: json["gowork"],
        holiday: json["holiday"],
        bookmark: json["bookmark"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
        "route": List<dynamic>.from(route.map((x) => x)),
        "schedule": List<dynamic>.from(schedule.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "gowork": gowork,
        "holiday": holiday,
        "bookmark": bookmark ?? false,
    };
}
