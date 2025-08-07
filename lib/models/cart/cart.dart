class CartModel {
  List<CartProductItem> item = [];
  int? countCart;
  String? totalPrice;
  CartModel({
    required this.item,
    this.countCart,
    this.totalPrice,
  });
  // Total price calculation
  double get prices {
    return item.fold(
        0, (total, item) => total + double.parse(item.price ?? '0'));
  }
  // Item count
  int get itemCount {
    return item.fold(0, (total, item) => total + int.parse(item.qty ?? '0'));
  }

  // CopyWith method for immutable updates
  CartModel copyWith({
    List<CartProductItem>? item,
    int? countCart,
    String? totalPrice,
  }) {
    return CartModel(
      item: item ?? this.item,
      countCart: countCart ?? this.countCart,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  String toString() {
    return 'Cart(items: $item)';
  }
}

class CartProductItem {
  String? productId;
  String? qty;
  String? price;
  String? productNameEn;
  String? photo;
  String? color;
  String? size;
  String? description;
  String? packagingId;
  String? packagingNote;
  String? packagingQty;
  String? packagingPrice;

  CartProductItem(
      {this.productId,
      this.qty,
      this.price,
      this.productNameEn,
      this.photo,
      this.size,
      this.color,
      this.description,
      this.packagingId,
      this.packagingNote,
      this.packagingQty,
      this.packagingPrice});

  // CopyWith method for immutable updates
  CartProductItem copyWith({
    String? productId,
    String? qty,
    String? price,
    String? productNameEn,
    String? photo,
    String? color,
    String? size,
    String? description,
    String? packagingId,
    String? packagingNote,
    String? packagingQty,
    String? packagingPrice,
  }) {
    return CartProductItem(
      productId: productId ?? this.productId,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      productNameEn: productNameEn ?? this.productNameEn,
      photo: photo ?? this.photo,
      color: color ?? this.color,
      size: size ?? this.size,
      description: description ?? this.description,
      packagingId: packagingId ?? this.packagingId,
      packagingNote: packagingNote ?? this.packagingNote,
      packagingQty: packagingQty ?? this.packagingQty,
      packagingPrice: packagingPrice ?? this.packagingPrice,
    );
  }
}
