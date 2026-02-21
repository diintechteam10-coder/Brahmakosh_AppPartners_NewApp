class SendMessageRequest {
  final String content;
  final String messageType;

  SendMessageRequest({
    required this.content,
    this.messageType = 'text',
  });

  /// Convert to JSON (for API body)
  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "messageType": messageType,
    };
  }

  /// Optional: fromJson (rarely needed for request models)
  factory SendMessageRequest.fromJson(Map<String, dynamic> json) {
    return SendMessageRequest(
      content: json["content"] ?? '',
      messageType: json["messageType"] ?? 'text',
    );
  }
}
