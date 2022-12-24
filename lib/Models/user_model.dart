class UserModel {
  String userid;
  String firstname;
  String lastname;
  String username;
  String email;
  String password;
  String number;
  String profilepicture;
  bool isOnline;

  UserModel({
    required this.userid,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.password,
    required this.number,
    required this.profilepicture,
    required this.isOnline,
  });

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'password': password,
      'number': number,
      'profilepicture': profilepicture,
      'isOnline': isOnline,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userid: map['userid'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      number: map['number'] ?? '',
      profilepicture: map['profilepicture'] ?? "",
      isOnline: map['isOnline'] ?? false,
    );
  }
}
