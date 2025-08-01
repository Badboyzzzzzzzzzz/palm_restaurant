import 'package:image_picker/image_picker.dart';

class ProfileParams {
  String? fullName;
  String? phone;
  String? email;
  String? hksId;
  String? gender;
  String? dateOfBirth;
  XFile? profile_photo;

  ProfileParams({
    this.fullName,
    this.phone,
    this.email,
    this.hksId,
    this.gender,
    this.dateOfBirth,
    this.profile_photo
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fullName != null) {
      data['name'] = this.fullName;
    }
    if (this.phone != null) {
      data['phone'] = this.phone;
    }
    if (this.email != null) {
      data['email'] = this.email;
    }
    if (this.hksId != null) {
      data['hks_id'] = this.hksId;
    }
    if (this.gender != null) {
      data['gender'] = this.gender;
    }
    if (this.dateOfBirth != null) {
      data['dob'] = this.dateOfBirth;
    }
    if (this.profile_photo != null) {
      data['profile_photo'] = this.profile_photo;
    }
    return data;
  }
}
