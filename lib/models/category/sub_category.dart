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
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubCategoryModel &&
          runtimeType == other.runtimeType &&
          productTypeId == other.productTypeId &&
          productCategId == other.productCategId &&
          productTypeEn == other.productTypeEn &&
          photo == other.photo &&
          subId == other.subId &&
          subCategoryName == other.subCategoryName &&
          mainCategoryId == other.mainCategoryId;
  @override
  int get hashCode =>
      productTypeId.hashCode ^
      productCategId.hashCode ^
      productTypeEn.hashCode ^
      photo.hashCode ^
      subId.hashCode ^
      subCategoryName.hashCode ^
      mainCategoryId.hashCode;
}
