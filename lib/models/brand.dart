class Branch {
  String? branchId;
  String? companyId;
  String? branchKm;
  String? branchEn;
  String? phone;
  String? email;
  String? addressEn;
  String? latitude;
  String? longitude;

  Branch(
      {this.branchId,
        this.companyId,
        this.branchKm,
        this.branchEn,
        this.phone,
        this.email,
        this.addressEn,
        this.latitude,
        this.longitude});

  Branch.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    companyId = json['company_id'];
    branchKm = json['branch_km'];
    branchEn = json['branch_en'];
    phone = json['phone'];
    email = json['email'];
    addressEn = json['address_en'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['company_id'] = companyId;
    data['branch_km'] = branchKm;
    data['branch_en'] = branchEn;
    data['phone'] = phone;
    data['email'] = email;
    data['address_en'] = addressEn;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
