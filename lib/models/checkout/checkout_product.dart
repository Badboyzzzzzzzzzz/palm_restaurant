class CheckoutProduct {
  String? id;
  String? productId;
  String? qty;
  String? price;
  String? photo;
  String? productNameEn;
  String? priceBeforeDiscount;
  String? amount;
  String? color;
  String? size;
  String? description;
  String? packagingID;
  String? packageNote;
  String? packageQTY;

  CheckoutProduct(
      {this.id,
      this.productId,
      this.qty,
      this.price,
      this.photo,
      this.productNameEn,
      this.priceBeforeDiscount,
      this.amount,
      this.color,
      this.size,
      this.description,
      this.packagingID,
      this.packageNote,
      this.packageQTY});

  @override
  bool operator ==(Object other) {
    return other is CheckoutProduct &&
        other.id == id &&
        other.productId == productId &&
        other.qty == qty &&
        other.price == price &&
        other.photo == photo &&
        other.productNameEn == productNameEn &&
        other.priceBeforeDiscount == priceBeforeDiscount &&
        other.amount == amount &&
        other.color == color &&
        other.size == size &&
        other.description == description &&
        other.packagingID == packagingID &&
        other.packageNote == packageNote &&
        other.packageQTY == packageQTY;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      productId.hashCode ^
      qty.hashCode ^
      price.hashCode ^
      photo.hashCode ^
      productNameEn.hashCode ^
      priceBeforeDiscount.hashCode ^
      amount.hashCode ^
      color.hashCode ^
      size.hashCode ^
      description.hashCode ^
      packagingID.hashCode ^
      packageNote.hashCode ^
      packageQTY.hashCode;
}
