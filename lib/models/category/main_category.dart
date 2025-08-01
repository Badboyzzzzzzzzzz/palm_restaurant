class MainCategoryModel {
  final String id;
  final String inventroyTypeKh;
  final String photo;
  final String inventroyType;
  final String mainCategoryName;

  MainCategoryModel(
      {required this.id,
      required this.inventroyTypeKh,
      required this.photo,
      required this.inventroyType,
      required this.mainCategoryName});

  @override
  bool operator ==(Object other) {
    return other is MainCategoryModel &&
        other.id == id &&
        other.mainCategoryName == mainCategoryName &&
        other.photo == photo;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      mainCategoryName.hashCode ^
      photo.hashCode;
}
