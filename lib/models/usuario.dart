class UserModel {
  String fullName;
  String username;
  String email;
  String phone;
  String country;

  UserModel({
    this.fullName = "",
    this.username = "",
    this.email = "",
    this.phone = "",
    this.country = "",
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      fullName: data["name"] ?? "",
      username: data["username"] ?? "",
      email: data["email"] ?? "",
      phone: data["phoneNumber"] ?? "",
      country: data["country"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": fullName,
      "username": username,
      "email": email,
      "phoneNumber": phone,
      "country": country,
    };
  }
}
