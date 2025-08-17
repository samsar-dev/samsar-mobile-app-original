class ChatUser {
  final String id;
  final String username;
  final String? profilePicture;
  final String? name;
  final String? email;
  final String? phone;
  final String? bio;

  ChatUser({
    required this.id,
    required this.username,
    this.profilePicture,
    this.name,
    this.email,
    this.phone,
    this.bio,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      username: json['username'],
      profilePicture: json['profilePicture'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      bio: json['bio'],
    );
  }
}
