class UserModel {
  String? accessToken;
  String? refreshToken;
  int? id;
  String? userName;
  String? email;
  String? firstName;
  String? lastName;
  String? gender;
  String? image;

  UserModel(
      {required this.accessToken,
      required this.refreshToken,
      required this.id,
      required this.userName,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        accessToken: json["accessToken"] ?? "",
        refreshToken: json["refreshToken"] ?? "",
        id: json["id"] ?? 0,
        userName: json["username"] ?? "",
        email: json["email"] ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        gender: json["gender"] ?? "",
        image: json["image"] ?? ""
    );
  }
}
