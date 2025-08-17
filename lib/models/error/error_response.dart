class ErrorResponse {
    ErrorResponse({
        required this.success,
        required this.error,
    });

    final bool? success;
    final Error? error;

    factory ErrorResponse.fromJson(Map<String, dynamic> json){ 
        return ErrorResponse(
            success: json["success"],
            error: json["error"] == null ? null : Error.fromJson(json["error"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "success": success,
        "error": error?.toJson(),
    };

    @override
    String toString(){
        return "$success, $error, ";
    }
}

class Error {
    Error({
        required this.code,
        required this.message,
        this.retryAfter,
    });

    final String? code;
    final String? message;
    final int? retryAfter;

    factory Error.fromJson(Map<String, dynamic> json){ 
        return Error(
            code: json["code"],
            message: json["message"],
            retryAfter: json["retryAfter"],
        );
    }

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        if (retryAfter != null) "retryAfter": retryAfter,
    };

    @override
    String toString(){
        return "$code, $message, ";
    }
}
