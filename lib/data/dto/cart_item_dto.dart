import 'package:palm_ecommerce_app/models/cart/cart.dart';

class CartItemDto{
  static CartProductItem fromJson(Map<String, dynamic> json){
    return CartProductItem(
      productId: json['product_id'],
      qty: json['qty'],
      price: json['price'],
      productNameEn: json['product_name_en'],
      photo: json['photo'],
      color: json['color'],
      size: json['size'],
      description: json['description'],
      packagingId: json['packaging_id'],
      packagingNote: json['packaging_note'],
      packagingQty: json['packaging_qty'],
      packagingPrice: json['packaging_price'],
    );
  }

  static Map<String, dynamic> toJson(CartProductItem item){
    return {
      'product_id': item.productId,
      'qty': item.qty,
      'price': item.price,
      'product_name_en': item.productNameEn,
      'photo': item.photo,
      'color': item.color,
      'size': item.size,
      'description': item.description,
      'packaging_id': item.packagingId,
      'packaging_note': item.packagingNote,
      'packaging_qty': item.packagingQty,
      'packaging_price': item.packagingPrice,
    };
  }
} 
