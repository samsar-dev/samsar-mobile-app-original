class GetSettingsModel {
    GetSettingsModel({
        required this.success,
        required this.data,
        required this.status,
    });

    final bool? success;
    final Data? data;
    final int? status;

    factory GetSettingsModel.fromJson(Map<String, dynamic> json){ 
        return GetSettingsModel(
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
    String toString(){
        return "$success, $data, $status, ";
    }
}

class Data {
    Data({
        required this.allowMessaging,
        required this.listingNotifications,
        required this.messageNotifications,
        required this.loginNotifications,
        required this.newsletterSubscribed,
        required this.showEmail,
        required this.showOnlineStatus,
        required this.showPhoneNumber,
        required this.privateProfile,
    });

    final bool? allowMessaging;
    final bool? listingNotifications;
    final bool? messageNotifications;
    final bool? loginNotifications;
    final bool? newsletterSubscribed;
    final bool? showEmail;
    final bool? showOnlineStatus;
    final bool? showPhoneNumber;
    final bool? privateProfile;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            allowMessaging: json["allowMessaging"],
            listingNotifications: json["listingNotifications"],
            messageNotifications: json["messageNotifications"],
            loginNotifications: json["loginNotifications"],
            newsletterSubscribed: json["newsletterSubscribed"],
            showEmail: json["showEmail"],
            showOnlineStatus: json["showOnlineStatus"],
            showPhoneNumber: json["showPhoneNumber"],
            privateProfile: json["privateProfile"],
        );
    }

    Map<String, dynamic> toJson() => {
        "allowMessaging": allowMessaging,
        "listingNotifications": listingNotifications,
        "messageNotifications": messageNotifications,
        "loginNotifications": loginNotifications,
        "newsletterSubscribed": newsletterSubscribed,
        "showEmail": showEmail,
        "showOnlineStatus": showOnlineStatus,
        "showPhoneNumber": showPhoneNumber,
        "privateProfile": privateProfile,
    };

    @override
    String toString(){
        return "$allowMessaging, $listingNotifications, $messageNotifications, $loginNotifications, $newsletterSubscribed, $showEmail, $showOnlineStatus, $showPhoneNumber, $privateProfile, ";
    }
}
