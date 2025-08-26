class FastifyErrorResponse {
  FastifyErrorResponse({
    required this.statusCode,
    required this.code,
    required this.error,
    required this.message,
  });

  final int? statusCode;
  final String? code;
  final String? error;
  final String? message;

  factory FastifyErrorResponse.fromJson(Map<String, dynamic> json) {
    return FastifyErrorResponse(
      statusCode: json["statusCode"],
      code: json["code"],
      error: json["error"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "code": code,
    "error": error,
    "message": message,
  };

  @override
  String toString() {
    return "$statusCode, $code, $error, $message, ";
  }
}
