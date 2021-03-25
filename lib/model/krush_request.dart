class KrushRequest {
  String userId;
  String krushName;
  String phoneNum;
  String message;
  String requestStatus;
  String sendCount;

  KrushRequest(
      {this.userId,
      this.krushName,
      this.phoneNum,
      this.message,
      this.requestStatus,
      this.sendCount});

  factory KrushRequest.fromJson(Map<String, dynamic> json) => KrushRequest(
        userId: json["userId"] == null ? null : json["userId"],
        krushName: json["krushName"] == null ? null : json["krushName"],
        phoneNum: json["phoneNum"] == null ? null : json["phoneNum"],
        message: json["message"] == null ? null : json["message"],
        requestStatus:
            json["requestStatus"] == null ? null : json["requestStatus"],
        sendCount: json["sendCount"] == null ? null : json["sendCount"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId == null ? null : userId,
        "krushName": krushName == null ? null : krushName,
        "phoneNum": phoneNum == null ? null : phoneNum,
        "message": message == null ? null : message,
        "requestStatus": requestStatus == null ? null : requestStatus,
        "sendCount": sendCount == null ? null : sendCount,
      };
}
