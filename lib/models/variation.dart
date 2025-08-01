class ProductVariationModel {
  List<Color> color = [];
  List<Size> size = [];

  ProductVariationModel({this.color = const [], this.size = const []});

  ProductVariationModel.fromJson(Map<String, dynamic> json) {
    if (json['color'] != null) {
      color = <Color>[];
      json['color'].forEach((v) {
        color.add( Color.fromJson(v));
      });
    }
    if (json['size'] != null) {
      size = <Size>[];
      json['size'].forEach((v) {
        size.add( Size.fromJson(v));
      });
    }
  }

  // tojson

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color.map((v) => v.toJson()).toList();
    data['size'] = size.map((v) => v.toJson()).toList();
    return data;
  }

}

class Color {
  String? productId;
  String? color;
  String? colorId;
  String? photo;
  int? active;

  Color({this.productId, this.color, this.colorId, this.photo, this.active});

  Color.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    color = json['color'];
    colorId = json['color_id'];
    photo = json['photo'];
    active = json['active'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['color'] = color;
    data['color_id'] = colorId;
    data['photo'] = photo;
    data['active'] = active;
    return data;
  }
}

class Size {
  String? productId;
  String? size;
  String? sizeId;
  int? active;

  Size({this.productId, this.size, this.sizeId, this.active});

  Size.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    size = json['size'];
    sizeId = json['size_id'];
    active = json['active'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['size'] = size;
    data['size_id'] = sizeId;
    data['active'] = active;
    return data;
  }

}