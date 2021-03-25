// To parse this JSON data, do
//
//     final action = actionFromJson(jsonString);

import 'dart:convert';

Action actionFromJson(String str) => Action.fromJson(json.decode(str));

String actionToJson(Action data) => json.encode(data.toJson());

class Action {
  String message;
  bool status;
  String reason;

  Action({
    this.message,
    this.status,
    this.reason,
  });

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        message: json["message"],
        status: json["status"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "reason": reason,
      };
}
