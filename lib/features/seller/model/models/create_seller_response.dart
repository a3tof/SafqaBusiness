class CreateSellerResponse {
  final bool isSuccess;
  final String? message;
  final int? sellerId;
  final String? token;
  final List<String> errors;

  CreateSellerResponse({
    required this.isSuccess,
    this.message,
    this.sellerId,
    this.token,
    this.errors = const [],
  });

  factory CreateSellerResponse.fromJson(Map<String, dynamic> json) {
    return CreateSellerResponse(
      isSuccess: (json['isSuccess'] ?? json['IsSuccess'] ?? false) as bool,
      message: (json['message'] ?? json['Message']) as String?,
      sellerId: (json['sellerId'] ?? json['SellerId']) as int?,
      token: (json['token'] ?? json['Token']) as String?,
      errors: _parseErrors(json['errors'] ?? json['Errors']),
    );
  }

  static List<String> _parseErrors(dynamic errors) {
    if (errors is List) {
      return errors.map((e) => e.toString()).toList();
    }
    return [];
  }
}
