class RegisterVerifyPhoneModel {
  String? token;
  String? name;
  String? email;
  String? phone;

  RegisterVerifyPhoneModel({this.token, this.name, this.email, this.phone});

  RegisterVerifyPhoneModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
