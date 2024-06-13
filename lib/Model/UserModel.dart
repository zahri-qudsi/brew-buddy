class UserModel {
  late int id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  int? verified;
  bool? limited;
  int? isDeleted;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstname'];
    lastName = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    verified = json['verified'];
    limited = json['limited'];
    isDeleted = json['isDeleted'];
  }
}
