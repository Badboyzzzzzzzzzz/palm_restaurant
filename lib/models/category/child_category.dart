import 'package:palm_ecommerce_app/models/category/sub_category.dart';

class ChildCategoryModel {
  String? id;
  String? productTypeId;
  String? name;
  String? nameKh;
  String? photo;
  String? subCategoryId;

  ChildCategoryModel(
      {this.id,
        this.productTypeId,
        this.name,
        this.nameKh,
        this.photo,
        this.subCategoryId});

  ChildCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productTypeId = json['product_type_id'];
    name = json['name'];
    nameKh = json['name_kh'];
    photo = json['photo'];
    subCategoryId = json['sub_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_type_id'] = productTypeId;
    data['name'] = name;
    data['name_kh'] = nameKh;
    data['photo'] = photo;
    data['sub_category_id'] = subCategoryId;
    return data;
  }
}

class SubAndChildCategoryModel extends SubCategoryModel {

  List<ChildCategoryModel>? childCategories;

  SubAndChildCategoryModel(
      { this.childCategories,
        super.productCategId,
        super.productTypeId,
        super.productTypeEn,
        super.photo,
        super.subId,
        super.subCategoryName,
        super.mainCategoryId
      });

  // from json
  SubAndChildCategoryModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['Child_category'] != null) {
      childCategories = [];
      json['Child_category'].forEach((v) {
        childCategories!.add(new ChildCategoryModel.fromJson(v));
      });
    } else {
      childCategories = [];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson(); // Call to the base class toJson
    if (childCategories != null) {
      data['child_categories'] = childCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}