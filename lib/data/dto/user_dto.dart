import 'package:palm_ecommerce_app/models/user/user_info.dart';

class UserDto {
  static UserInfo fromJson(String token, dynamic json) {
    if (json is String) {
      // If json is a string (token), create a basic user info
      return UserInfo.empty();
    } else if (json is Map<String, dynamic>) {
      // If json is a map, use the existing logic
      return UserInfo(
        id: json["id"]?.toString() ?? '',
        profile_image: json["profile_image"]?.toString() ?? '',
        transaction: json["transaction"]?.toString() ?? '',
        name: json["name"]?.toString() ?? '',
        phone: json["phone"]?.toString() ?? '',
        email: json["email"]?.toString() ?? '',
        status: json["status"]?.toString() ?? '0',
        start_at: json["start_at"]?.toString() ?? '',
        expire_at: json["expire_at"]?.toString() ?? '',
        term: json["term"]?.toString() ?? '',
        package: json["package"]?.toString() ?? '',
      );
    } else {
      throw Exception('Invalid data format for UserInfo');
    }
  }

  static Map<String, dynamic> toJson(UserInfo user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'profile_image': user.profile_image,
      'transaction': user.transaction,
      'status': user.status,
      'start_at': user.start_at,
      'expire_at': user.expire_at,
      'term': user.term,
      'package': user.package,
    };
  }
}
