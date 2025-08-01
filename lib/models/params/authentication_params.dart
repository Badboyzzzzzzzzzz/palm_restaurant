class RegisterParam {
  String name;
  String email;
  String password;
  String c_password;
  String phone;

  RegisterParam(
      {required this.name, required this.email, required this.password, required this.c_password, required this.phone});

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'c_password': c_password,
    'phone': phone.startsWith('0') ? phone.substring(1) : phone,
    'prefix': "+855"
  };
}
/*
{
    "social_type": "google",
    "token": "data",
    "phone": "0968666539",
    "verify_code": ""
}
 */

enum SocialType { facebook, google, apple }

class SocialLoginParam {
  SocialType social_type;
  String token;
  String phone;
  String verify_code;

  SocialLoginParam({required this.social_type, required this.token, required this.phone, required this.verify_code});

  Map<String, dynamic> toJson() => {
    'social_type': social_type.toString().split('.').last,
    'token': token,
    'phone': phone.startsWith('0') ? phone.substring(1) : phone,
    'verify_code': verify_code
  };


}