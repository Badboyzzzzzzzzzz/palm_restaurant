import 'package:palm_ecommerce_app/data/dto/checkout_dto/checkout_product_dto.dart';
import 'package:palm_ecommerce_app/models/checkout/checkout.dart';

class CheckoutDto {
  static CheckoutModel fromJson(Map<String, dynamic> json) {
    String? toStringValue(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    return CheckoutModel(
      voucherId: toStringValue(json['voucher_id']),
      voucherAmount: toStringValue(json['voucher_amount']),
      point: toStringValue(json['point']),
      pointAmount: toStringValue(json['point_amount']),
      deliveryFee: toStringValue(json['delivery_fee']),
      packaging: toStringValue(json['packaging']),
      packagingDescription: toStringValue(json['packaging_description']),
      taxAmount: toStringValue(json['tax_amount']),
      totalPrice: toStringValue(json['total_price']),
      totalDiscountPrice: toStringValue(json['total_discount_price']),
      totalPriceOfterDiscount:
          toStringValue(json['total_price_ofter_discount']),
      grandTotal: toStringValue(json['grand_total']),
      product: (json['product'] as List<dynamic>?)
          ?.map((item) => CheckoutProductDto.fromJson(item))
          .toList(),
    );
  }

  static Map<String, dynamic> toJson(CheckoutModel checkout) {
    return {
      'voucher_id': checkout.voucherId,
      'voucher_amount': checkout.voucherAmount,
      'point': checkout.point,
      'point_amount': checkout.pointAmount,
      'delivery_fee': checkout.deliveryFee,
      'packaging': checkout.packaging,
      'packaging_description': checkout.packagingDescription,
      'tax_amount': checkout.taxAmount,
      'total_price': checkout.totalPrice,
      'total_discount_price': checkout.totalDiscountPrice,
      'total_price_ofter_discount': checkout.totalPriceOfterDiscount,
      'grand_total': checkout.grandTotal,
      'product': checkout.product
          ?.map((item) => CheckoutProductDto.toJson(item))
          .toList(),
    };
  }
}
