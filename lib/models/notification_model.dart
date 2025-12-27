import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

class NotificationModel {
  bool? status;
  String? message;
  NotificationResult? result;

  NotificationModel({
    this.status,
    this.message,
    this.result,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    status: json["status"],
    message: json["message"],
    result: json["result"] == null ? null : NotificationResult.fromJson(json["result"]),
  );
}

class NotificationResult {
  String? dashboardNotification;
  List<NotificationItem>? notification;

  NotificationResult({
    this.dashboardNotification,
    this.notification,
  });

  factory NotificationResult.fromJson(Map<String, dynamic> json) => NotificationResult(
    dashboardNotification: json["dashboard_notification"],
    notification: json["notification"] == null
        ? []
        : List<NotificationItem>.from(json["notification"]!.map((x) => NotificationItem.fromJson(x))),
  );
}

class NotificationItem {
  String? id;
  String? title;
  String? url;
  String? status; // "active" or "deactive"
  String? createdAt;
  String? updatedAt;

  NotificationItem({
    this.id,
    this.title,
    this.url,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    id: json["id"],
    title: json["title"],
    url: json["url"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  // Helper to check if active
  bool get isActive => status?.toLowerCase() == 'active';
}