class LoginModel {
    LoginModel({
        required this.success,
        required this.data,
    });

    final bool? success;
    final Data? data;

    factory LoginModel.fromJson(Map<String, dynamic> json){ 
        return LoginModel(
            success: json["success"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };

    @override
    String toString(){
        return "$success, $data, ";
    }
}

class Data {
    Data({
        required this.tokens,
        required this.user,
    });

    final Tokens? tokens;
    final User? user;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            tokens: json["tokens"] == null ? null : Tokens.fromJson(json["tokens"]),
            user: json["user"] == null ? null : User.fromJson(json["user"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "tokens": tokens?.toJson(),
        "user": user?.toJson(),
    };

    @override
    String toString(){
        return "$tokens, $user, ";
    }
}

class Tokens {
    Tokens({
        required this.accessToken,
        required this.refreshToken,
    });

    final String? accessToken;
    final String? refreshToken;

    factory Tokens.fromJson(Map<String, dynamic> json){ 
        return Tokens(
            accessToken: json["accessToken"],
            refreshToken: json["refreshToken"],
        );
    }

    Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
    };

    @override
    String toString(){
        return "$accessToken, $refreshToken, ";
    }
}

class User {
    User({
        required this.id,
        required this.email,
        required this.username,
        required this.role,
        required this.createdAt,
        required this.updatedAt,
        required this.phone,
        required this.profilePicture,
        required this.bio,
        required this.name,
        required this.dateOfBirth,
        required this.street,
        required this.city,
        required this.allowMessaging,
        required this.listingNotifications,
        required this.messageNotifications,
        required this.loginNotifications,
        required this.showEmail,
        required this.showOnlineStatus,
        required this.showPhoneNumber,
        required this.privateProfile,
    });

    final String? id;
    final String? email;
    final String? username;
    final String? role;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? phone;
    final dynamic profilePicture;
    final String? bio;
    final String? name;
    final dynamic dateOfBirth;
    final String? street;
    final String? city;
    final bool? allowMessaging;
    final bool? listingNotifications;
    final bool? messageNotifications;
    final bool? loginNotifications;
    final bool? showEmail;
    final bool? showOnlineStatus;
    final bool? showPhoneNumber;
    final bool? privateProfile;

    factory User.fromJson(Map<String, dynamic> json){ 
        return User(
            id: json["id"],
            email: json["email"],
            username: json["username"],
            role: json["role"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            phone: json["phone"],
            profilePicture: json["profilePicture"],
            bio: json["bio"],
            name: json["name"],
            dateOfBirth: json["dateOfBirth"],
            street: json["street"],
            city: json["city"],
            allowMessaging: json["allowMessaging"],
            listingNotifications: json["listingNotifications"],
            messageNotifications: json["messageNotifications"],
            loginNotifications: json["loginNotifications"],
            showEmail: json["showEmail"],
            showOnlineStatus: json["showOnlineStatus"],
            showPhoneNumber: json["showPhoneNumber"],
            privateProfile: json["privateProfile"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "role": role,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "phone": phone,
        "profilePicture": profilePicture,
        "bio": bio,
        "name": name,
        "dateOfBirth": dateOfBirth,
        "street": street,
        "city": city,
        "allowMessaging": allowMessaging,
        "listingNotifications": listingNotifications,
        "messageNotifications": messageNotifications,
        "loginNotifications": loginNotifications,
        "showEmail": showEmail,
        "showOnlineStatus": showOnlineStatus,
        "showPhoneNumber": showPhoneNumber,
        "privateProfile": privateProfile,
    };

    @override
    String toString(){
        return "$id, $email, $username, $role, $createdAt, $updatedAt, $phone, $profilePicture, $bio, $name, $dateOfBirth, $street, $city, $allowMessaging, $listingNotifications, $messageNotifications, $loginNotifications, $showEmail, $showOnlineStatus, $showPhoneNumber, $privateProfile, ";
    }
}
