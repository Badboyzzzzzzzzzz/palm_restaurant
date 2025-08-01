class Company {
  String? companyId;
  String? companyCode;
  String? companyNameKm;
  String? companyNameEn;
  String? companyPhone;
  String? companyEmail;
  String? village;
  String? addressEn;
  String? companyProfile;

  Company(
      {this.companyId,
        this.companyCode,
        this.companyNameKm,
        this.companyNameEn,
        this.companyPhone,
        this.companyEmail,
        this.village,
        this.addressEn,
        this.companyProfile});

  Company.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    companyCode = json['company_code'];
    companyNameKm = json['company_name_km'];
    companyNameEn = json['company_name_en'];
    companyPhone = json['company_phone'];
    companyEmail = json['company_email'];
    village = json['village'];
    addressEn = json['address_en'];
    companyProfile = json['company_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_id'] = companyId;
    data['company_code'] = companyCode;
    data['company_name_km'] = companyNameKm;
    data['company_name_en'] = companyNameEn;
    data['company_phone'] = companyPhone;
    data['company_email'] = companyEmail;
    data['village'] = village;
    data['address_en'] = addressEn;
    data['company_profile'] = companyProfile;
    return data;
  }
}
