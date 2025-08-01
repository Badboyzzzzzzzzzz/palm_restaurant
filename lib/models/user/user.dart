class Users {
  String? name;
  String? phone;
  String? email;
  String? status;
  String? token;
  String? id;
  String? gender;
  String? hskId;
  String? dob;
  String? profileImage;
  String? point;
  String? card;
  bool facebook;
  bool google;
  bool apple;

  Users({
    this.name,
    this.phone,
    this.email,
    this.status,
    this.token,
    this.id,
    this.gender,
    this.hskId,
    this.dob,
    this.profileImage,
    this.point,
    this.card,
    this.facebook = false,
    this.google = false,
    this.apple = false,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    String? idStr = json['id']?.toString() ?? '';
    String? genderStr = json['gender']?.toString() ?? '';
    String? hskIdStr = json['hsk_id']?.toString() ?? '';
    return Users(
      name: json['name']?.toString() ?? '',
      phone: _cleanPhoneNumber(json['phone']?.toString()) ?? '',
      email: json['email']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      id: idStr,
      gender: genderStr,
      hskId: hskIdStr,
      dob: json['dob']?.toString() ?? '',
      profileImage: json['profile_image']?.toString() ?? '',
      point: json['point']?.toString() ?? '0',
      card: json['card_number']?.toString() ?? '',
      facebook: json['facebook'] ?? false,
      google: json['google'] ?? false,
      apple: json['apple'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'status': status,
      'token': token,
      'id': id,
      'gender': gender,
      'hsk_id': hskId,
      'dob': dob,
      'profile_image': profileImage,
      'point': point,
      'card_number': card,
      'facebook': facebook,
      'google': google,
      'apple': apple,
    };
  }

  static String? _cleanPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null) return null;
    // If the number starts with "00", remove only the first "0"
    if (phoneNumber.startsWith('00')) {
      return phoneNumber.replaceFirst('0', '');
    }
    // Otherwise, return the number as-is
    return phoneNumber;
  }
}
