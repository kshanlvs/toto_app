class UserModel {
  String? email;
  String? name;
  String? token;
  UserModel({this.email,this.name,this.token});
  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    data['email'] = email;
    data['name'] = name;
    data['token'] = token;

    return data;
  }
}
