class SubCategoryModel {
  String? productTypeId;
  String? productCategId;
  String? productTypeEn;
  String? photo;
  String? subId;
  String? subCategoryName;
  String? mainCategoryId;

  SubCategoryModel(
      {this.productTypeId,
        this.productCategId,
        this.productTypeEn,
        this.photo,
        this.subId,
        this.subCategoryName,
        this.mainCategoryId});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    productTypeId = json['product_type_id'];
    productCategId = json['product_categ_id'];
    productTypeEn = json['product_type_en'];
    photo = json['photo'];
    subId = json['sub_id'];
    subCategoryName = json['sub_category_name'];
    mainCategoryId = json['main_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_type_id'] = productTypeId;
    data['product_categ_id'] = productCategId;
    data['product_type_en'] = productTypeEn;
    data['photo'] = photo;
    data['sub_id'] = subId;
    data['sub_category_name'] = subCategoryName;
    data['main_category_id'] = mainCategoryId;
    return data;
  }
}
