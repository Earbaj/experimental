class UserEntity {
  String? accessToken;
  String? refreshToken;
  int? id;
  String? userName;
  String? email;
  String? firstName;
  String? lastName;
  String? gender;
  String? image;

  UserEntity(
  {
    required this.accessToken,
      required this.refreshToken,
      required this.id,
      required this.userName,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.image}
      );
}