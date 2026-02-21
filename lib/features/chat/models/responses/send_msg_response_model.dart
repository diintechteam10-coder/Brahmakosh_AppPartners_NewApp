class SendMessageResponse {
  final bool success;
  final ChatMessageData? data;

  SendMessageResponse({
    required this.success,
    required this.data,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      success: json["success"] ?? false,
      data: json["data"] != null
          ? ChatMessageData.fromJson(json["data"])
          : null,
    );
  }
}
class ChatMessageData {
  final String id;
  final String conversationId;
  final SenderInfo senderId;
  final String senderModel;
  final String receiverId;
  final String receiverModel;
  final String messageType;
  final String content;
  final String? mediaUrl;
  final bool isRead;
  final DateTime? readAt;
  final bool isDelivered;
  final DateTime? deliveredAt;
  final bool isDeleted;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessageData({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderModel,
    required this.receiverId,
    required this.receiverModel,
    required this.messageType,
    required this.content,
    required this.mediaUrl,
    required this.isRead,
    required this.readAt,
    required this.isDelivered,
    required this.deliveredAt,
    required this.isDeleted,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessageData.fromJson(Map<String, dynamic> json) {
    return ChatMessageData(
      id: json["_id"] ?? '',
      conversationId: json["conversationId"] ?? '',
      senderId: SenderInfo.fromJson(json["senderId"]),
      senderModel: json["senderModel"] ?? '',
      receiverId: json["receiverId"] ?? '',
      receiverModel: json["receiverModel"] ?? '',
      messageType: json["messageType"] ?? 'text',
      content: json["content"] ?? '',
      mediaUrl: json["mediaUrl"],
      isRead: json["isRead"] ?? false,
      readAt:
          json["readAt"] != null ? DateTime.tryParse(json["readAt"]) : null,
      isDelivered: json["isDelivered"] ?? false,
      deliveredAt: json["deliveredAt"] != null
          ? DateTime.tryParse(json["deliveredAt"])
          : null,
      isDeleted: json["isDeleted"] ?? false,
      deletedAt: json["deletedAt"] != null
          ? DateTime.tryParse(json["deletedAt"])
          : null,
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }
}
class SenderInfo {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final bool? isAvailable;

  SenderInfo({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    this.isAvailable,
  });

  factory SenderInfo.fromJson(Map<String, dynamic> json) {
    return SenderInfo(
      id: json["_id"] ?? json["id"] ?? '',
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      profilePicture: json["profilePicture"],
      isAvailable: json["isAvailable"],
    );
  }
}
