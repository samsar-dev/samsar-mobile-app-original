class UpdateSettingsModel {
  UpdateSettingsModel({
    required this.success,
    required this.data,
    required this.status,
  });

  final bool? success;
  final Data? data;
  final int? status;

  factory UpdateSettingsModel.fromJson(Map<String, dynamic> json) {
    return UpdateSettingsModel(
      success: json["success"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "status": status,
  };

  @override
  String toString() {
    return "$success, $data, $status, ";
  }
}

class Data {
  Data({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    required this.profilePicture,
    required this.bio,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.preferences,
    required this.city,
    required this.dateOfBirth,
    required this.street,
    required this.refreshToken,
    required this.refreshTokenExpiresAt,
    required this.phone,
    required this.emailVerified,
    required this.lastVerifiedAt,
    required this.verificationToken,
    required this.verificationCode,
    required this.verificationTokenExpires,
    required this.accountStatus,
    required this.allowMessaging,
    required this.listingNotifications,
    required this.messageNotifications,
    required this.showEmail,
    required this.showOnlineStatus,
    required this.showPhoneNumber,
    required this.maxListings,
    required this.listingRestriction,
    required this.subscriptionId,
    required this.subscriptionStatus,
    required this.subscriptionEndsAt,
    required this.latitude,
    required this.longitude,
    required this.lastActiveAt,
    required this.newsletterSubscribed,
    required this.loginNotifications,
    required this.privateProfile,
  });

  final String? id;
  final String? email;
  final String? name;
  final String? username;
  final String? profilePicture;
  final String? bio;
  final dynamic location;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? role;
  final dynamic preferences;
  final String? city;
  final dynamic dateOfBirth;
  final String? street;
  final String? refreshToken;
  final DateTime? refreshTokenExpiresAt;
  final String? phone;
  final bool? emailVerified;
  final DateTime? lastVerifiedAt;
  final dynamic verificationToken;
  final dynamic verificationCode;
  final dynamic verificationTokenExpires;
  final String? accountStatus;
  final bool? allowMessaging;
  final bool? listingNotifications;
  final bool? messageNotifications;
  final bool? showEmail;
  final bool? showOnlineStatus;
  final bool? showPhoneNumber;
  final int? maxListings;
  final String? listingRestriction;
  final dynamic subscriptionId;
  final String? subscriptionStatus;
  final dynamic subscriptionEndsAt;
  final dynamic latitude;
  final dynamic longitude;
  final DateTime? lastActiveAt;
  final bool? newsletterSubscribed;
  final bool? loginNotifications;
  final bool? privateProfile;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      username: json["username"],
      profilePicture: json["profilePicture"],
      bio: json["bio"],
      location: json["location"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      role: json["role"],
      preferences: json["preferences"],
      city: json["city"],
      dateOfBirth: json["dateOfBirth"],
      street: json["street"],
      refreshToken: json["refreshToken"],
      refreshTokenExpiresAt: DateTime.tryParse(
        json["refreshTokenExpiresAt"] ?? "",
      ),
      phone: json["phone"],
      emailVerified: json["emailVerified"],
      lastVerifiedAt: DateTime.tryParse(json["lastVerifiedAt"] ?? ""),
      verificationToken: json["verificationToken"],
      verificationCode: json["verificationCode"],
      verificationTokenExpires: json["verificationTokenExpires"],
      accountStatus: json["accountStatus"],
      allowMessaging: json["allowMessaging"],
      listingNotifications: json["listingNotifications"],
      messageNotifications: json["messageNotifications"],
      showEmail: json["showEmail"],
      showOnlineStatus: json["showOnlineStatus"],
      showPhoneNumber: json["showPhoneNumber"],
      maxListings: json["maxListings"],
      listingRestriction: json["listingRestriction"],
      subscriptionId: json["subscriptionId"],
      subscriptionStatus: json["subscriptionStatus"],
      subscriptionEndsAt: json["subscriptionEndsAt"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      lastActiveAt: DateTime.tryParse(json["last_active_at"] ?? ""),
      newsletterSubscribed: json["newsletterSubscribed"],
      loginNotifications: json["loginNotifications"],
      privateProfile: json["privateProfile"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "username": username,
    "profilePicture": profilePicture,
    "bio": bio,
    "location": location,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "role": role,
    "preferences": preferences,
    "city": city,
    "dateOfBirth": dateOfBirth,
    "street": street,
    "refreshToken": refreshToken,
    "refreshTokenExpiresAt": refreshTokenExpiresAt?.toIso8601String(),
    "phone": phone,
    "emailVerified": emailVerified,
    "lastVerifiedAt": lastVerifiedAt?.toIso8601String(),
    "verificationToken": verificationToken,
    "verificationCode": verificationCode,
    "verificationTokenExpires": verificationTokenExpires,
    "accountStatus": accountStatus,
    "allowMessaging": allowMessaging,
    "listingNotifications": listingNotifications,
    "messageNotifications": messageNotifications,
    "showEmail": showEmail,
    "showOnlineStatus": showOnlineStatus,
    "showPhoneNumber": showPhoneNumber,
    "maxListings": maxListings,
    "listingRestriction": listingRestriction,
    "subscriptionId": subscriptionId,
    "subscriptionStatus": subscriptionStatus,
    "subscriptionEndsAt": subscriptionEndsAt,
    "latitude": latitude,
    "longitude": longitude,
    "last_active_at": lastActiveAt?.toIso8601String(),
    "newsletterSubscribed": newsletterSubscribed,
    "loginNotifications": loginNotifications,
    "privateProfile": privateProfile,
  };

  @override
  String toString() {
    return "$id, $email, $name, $username, $profilePicture, $bio, $location, $createdAt, $updatedAt, $role, $preferences, $city, $dateOfBirth, $street, $refreshToken, $refreshTokenExpiresAt, $phone, $emailVerified, $lastVerifiedAt, $verificationToken, $verificationCode, $verificationTokenExpires, $accountStatus, $allowMessaging, $listingNotifications, $messageNotifications, $showEmail, $showOnlineStatus, $showPhoneNumber, $maxListings, $listingRestriction, $subscriptionId, $subscriptionStatus, $subscriptionEndsAt, $latitude, $longitude, $lastActiveAt, $newsletterSubscribed, $loginNotifications, $privateProfile, ";
  }
}
