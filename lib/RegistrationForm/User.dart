class User {
  String firstName,
      lastName,
      email,
      password,
      confirmPassword,
      username,
      id,
      instructorId;

  bool status;
  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.confirmPassword,
      this.username,
      this.instructorId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        username: json['username']);
  }
  Map toLogin() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    return map;
  }
}
