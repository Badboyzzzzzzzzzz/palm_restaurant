class DriverAddress {
  String? nameEn;
  String? phone1;
  String? phone2;
  String? address;
  String? idCard;

  DriverAddress(
      {this.nameEn, this.phone1, this.phone2, this.address, this.idCard});

  DriverAddress.fromJson(Map<String, dynamic> json) {
    nameEn = json['name_en'];
    phone1 = json['phone1'] ?? "";
    phone2 = json['phone2'] ?? "";
    address = json['address'];
    idCard = json['id_card'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name_en'] = nameEn;
    data['phone1'] = phone1;
    data['phone2'] = phone2;
    data['address'] = address;
    data['id_card'] = idCard;
    return data;
  }
}
