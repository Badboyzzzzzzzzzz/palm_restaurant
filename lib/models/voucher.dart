class VoucherModel {
  String? voucherId;
  String? voucherName;
  String? amount;
  String? dateExpired;
  String? description;
  String? isExpired;
  String? photo;

  VoucherModel(
      {this.voucherId,
        this.voucherName,
        this.amount,
        this.dateExpired,
        this.description,
        this.photo,
        this.isExpired});

  VoucherModel.fromJson(Map<String, dynamic> json) {
    voucherId = json['voucher_id'].toString();
    voucherName = json['voucher_name'].toString();
    amount = json['amount'].toString();
    dateExpired = json['date_expired'].toString();
    description = json['description'].toString();
    isExpired = json['is_expired'].toString();
    photo = json["photo"].toString();
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['voucher_id'] = voucherId;
    data['voucher_name'] = voucherName;
    data['amount'] = amount;
    data['date_expired'] = dateExpired;
    data['description'] = description;
    data['is_expired'] = isExpired;
    data['photo'] = photo;
    return data;
  }

}
