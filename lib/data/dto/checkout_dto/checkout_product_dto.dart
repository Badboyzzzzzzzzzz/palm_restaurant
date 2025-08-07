import 'package:palm_ecommerce_app/models/checkout/checkout_product.dart';

class CheckoutProductDto {
  static CheckoutProduct fromJson(Map<String, dynamic> json) {
    String? toStringValue(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }
    return CheckoutProduct(
      id: toStringValue(json['id']),
      productId: toStringValue(json['product_id']),
      qty: toStringValue(json['qty']),
      price: toStringValue(json['price']),
      photo: toStringValue(json['photo']),
      productNameEn: toStringValue(json['product_name_en']),
      priceBeforeDiscount: toStringValue(json['price_before_discount']),
      amount: toStringValue(json['amount']),
      color: toStringValue(json['color']),
      size: toStringValue(json['size']),
      description: toStringValue(json['description']),
      packagingID: toStringValue(json['packaging_id']),
      packageNote: toStringValue(json['packaging_note']),
      packageQTY: toStringValue(json['packaging_qty']),
    );
  }
  static Map<String, dynamic> toJson(CheckoutProduct product) {
    return {
      'id': product.id,
      'product_id': product.productId,
      'qty': product.qty,
      'price': product.price,
      'photo': product.photo,
      'product_name_en': product.productNameEn,
      'price_before_discount': product.priceBeforeDiscount,
      'amount': product.amount,
      'color': product.color,
      'size': product.size,
      'description': product.description,
      'packaging_id': product.packagingID,
      'packaging_note': product.packageNote,
      'packaging_qty': product.packageQTY,
    };
  }
}
