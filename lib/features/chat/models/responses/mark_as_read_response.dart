class MarkAsReadResponse {
  final bool success;
  final String? message;

  MarkAsReadResponse({
    required this.success,
    required this.message,
  });

  factory MarkAsReadResponse.fromJson(Map<String, dynamic> json) {
    return MarkAsReadResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
