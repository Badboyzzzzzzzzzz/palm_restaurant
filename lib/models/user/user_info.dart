// ignore_for_file: non_constant_identifier_names

class UserInfo {
  final String id;
  final String profile_image;
  final String transaction;
  final String name;
  final String phone;
  final String email;
  final String status;
  final String start_at;
  final String expire_at;
  final String term;
  final String package;
  UserInfo(
      {required this.id,
      required this.profile_image,
      required this.transaction,
      required this.name,
      required this.phone,
      required this.email,
      required this.status,
      required this.start_at,
      required this.expire_at,
      required this.term,
      required this.package});

  // Add a copyWith method directly in the model
  UserInfo copyWith({
    String? id,
    String? profileImage,
    String? transaction,
    String? name,
    String? phone,
    String? email,
    String? status,
    String? startAt,
    String? expireAt,
    String? term,
    String? package,
  }) {
    return UserInfo(
      id: id ?? this.id,
      profile_image: profileImage ?? profile_image,
      transaction: transaction ?? this.transaction,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      status: status ?? this.status,
      start_at: startAt ?? start_at,
      expire_at: expireAt ?? expire_at,
      term: term ?? this.term,
      package: package ?? this.package,
    );
  }

  // Create an empty user
  static UserInfo empty() {
    return UserInfo(
      id: '',
      profile_image: '',
      transaction: '',
      name: '',
      phone: '',
      email: '',
      status: '0',
      start_at: '',
      expire_at: '',
      term: '',
      package: '',
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserInfo &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      email.hashCode;
}
