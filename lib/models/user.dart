class User {
  String id;
  String name;
  String email;
  String password;
  String address;
  String phone;
  String token;
  User({required this.id,required this.name, required this.email, required this.password, required this.address, required this.phone, required this.token});
  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     username: json['username'],
  //     email: json['email'],
  //     password: json['password']
  //   );
  // }
}

class UserCredential {
  String email;
  String password;
  UserCredential({required this.email, required this.password});
}
