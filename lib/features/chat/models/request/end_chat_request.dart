class EndChatRequest {
  final int stars;
  final String feedback;
  final String satisfaction;

  EndChatRequest({
    required this.stars,
    required this.feedback,
    required this.satisfaction,
  });

  Map<String, dynamic> toJson() {
    return {"stars": stars, "feedback": feedback, "satisfaction": satisfaction};
  }
}
