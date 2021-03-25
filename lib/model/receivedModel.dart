class ReceivedContactModel {
  int id;
  String contactName;
  String contactPhone;
  int userId;
  DateTime created_at;
  DateTime updated_at;
  
  ReceivedContactModel({
    this.id,
    this.contactName,
    this.contactPhone,
    this.userId,
    this.created_at,
    this.updated_at
  });

  factory ReceivedContactModel.fromJson(Map<String, dynamic> json) => ReceivedContactModel(
        id: json["id"] == null ? null : json["id"],
        contactName: json["contactName"] == null ? null : json["contactName"],
        contactPhone: json["contactPhone"] == null ? null : json["contactPhone"],
        userId: json["userId"] == null ? null : json["userId"],
        created_at: json["created_at"] == null ? null :DateTime.parse(json["created_at"]),
        updated_at: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "contactName": contactName == null ? null : contactName,
        "contactPhone": contactPhone == null ? null : contactPhone,
        "userId": userId == null ? null : userId,
        "created_at": created_at == null ? null : created_at.toIso8601String(),
        "updated_at": updated_at == null ? null : updated_at.toIso8601String(),

      };
}