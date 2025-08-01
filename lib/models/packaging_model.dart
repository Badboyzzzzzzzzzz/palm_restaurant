class PackagingModel {
  String? packagingEn;
  String? packagingKh;
  String? price;
  String? descriptionEn;
  String? descriptionKh;
  String? photo;
  String? id;

  PackagingModel(
      {this.packagingEn,
      this.packagingKh,
      this.price,
      this.descriptionEn,
      this.descriptionKh,
      this.photo,
      this.id});

  PackagingModel.fromJson(Map<String, dynamic> json) {
    packagingEn = json['packaging_en'];
    packagingKh = json['packaging_kh'];
    price = json['price'];
    descriptionEn = json['description_en'];
    descriptionKh = json['description_kh'];
    photo = json['photo'];
    id = json['id'];
  }
}

class CheckoutPackagingModel {
  String? description;
  String? price;

  CheckoutPackagingModel({this.description, this.price});

  CheckoutPackagingModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['price'] = price;
    return data;
  }
}
