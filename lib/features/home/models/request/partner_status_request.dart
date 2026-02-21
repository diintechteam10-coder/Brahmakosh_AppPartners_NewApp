class UpdatePartnerStatusRequest {
  final String status;

  UpdatePartnerStatusRequest({
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "status": status,
    };
  }
}
