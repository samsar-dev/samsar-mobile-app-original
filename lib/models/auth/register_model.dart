class RegisterModel {
  RegisterModel({required this.success, required this.message});

  final bool? success;
  final String? message;

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(success: json["success"], message: json["message"]);
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message};

  @override
  String toString() {
    return "$success, $message, ";
  }
}
