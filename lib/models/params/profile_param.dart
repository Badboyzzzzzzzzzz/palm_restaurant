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
    this.profile_photo,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (fullName != null) {
      data['name'] = fullName;
    }

    if (phone != null) {
      data['phone'] = phone;
    }

    if (email != null) {
      data['email'] = email;
    }

    if (hksId != null) {
      data['hks_id'] = hksId;
    }

    if (gender != null) {
      if (gender == 'Male') {
        data['gender'] = '1';
      } else if (gender == 'Female') {
        data['gender'] = '2';
      } else {
        data['gender'] = gender;
      }
    }

    if (dateOfBirth != null) {
      try {
        if (dateOfBirth!.contains('-')) {
          final parts = dateOfBirth!.split('-');
          if (parts.length == 3) {
            data['dob'] = '${parts[1]}/${parts[2]}/${parts[0]}';
          } else {
            data['dob'] = dateOfBirth;
          }
        } else {
          data['dob'] = dateOfBirth;
        }
      } catch (e) {
        data['dob'] = dateOfBirth;
      }
    }
    return data;
  }
  bool hasProfilePhotoUpdate() {
    return profile_photo != null;
  }
  Future<Map<String, dynamic>> toMultipartRequestFields() async {
    final Map<String, dynamic> formFields = toJson();
    return formFields;
  }
}
