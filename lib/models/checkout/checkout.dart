import 'package:palm_ecommerce_app/models/checkout/checkout_product.dart';

class CheckoutModel {
  String? voucherId;
  String? voucherAmount;
  String? point;
  String? pointAmount;
  String? deliveryFee;
  String? packaging;
  String? packagingDescription;
  String? taxAmount;
  String? totalPrice;
  String? totalDiscountPrice;
  String? totalPriceOfterDiscount;
  String? grandTotal;
  List<CheckoutProduct>? product = [];

  CheckoutModel(
      {this.voucherId,
      this.voucherAmount,
      this.point,
      this.pointAmount,
      this.deliveryFee,
      this.packaging,
      this.packagingDescription,
      this.taxAmount,
      this.totalPrice,
      this.totalDiscountPrice,
      this.totalPriceOfterDiscount,
      this.grandTotal,
      this.product});
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckoutModel &&
          runtimeType == other.runtimeType &&
          voucherId == other.voucherId &&
          voucherAmount == other.voucherAmount &&
          point == other.point &&
          pointAmount == other.pointAmount &&
          deliveryFee == other.deliveryFee &&
          packaging == other.packaging &&
          packagingDescription == other.packagingDescription &&
          taxAmount == other.taxAmount &&
          totalPrice == other.totalPrice &&
          totalDiscountPrice == other.totalDiscountPrice &&
          totalPriceOfterDiscount == other.totalPriceOfterDiscount &&
          grandTotal == other.grandTotal &&
          product == other.product;
  @override
  int get hashCode =>
      super.hashCode ^
      voucherId.hashCode ^
      voucherAmount.hashCode ^
      point.hashCode ^
      pointAmount.hashCode ^
      deliveryFee.hashCode ^
      packaging.hashCode ^
      packagingDescription.hashCode ^
      taxAmount.hashCode ^
      totalPrice.hashCode ^
      totalDiscountPrice.hashCode ^
      totalPriceOfterDiscount.hashCode ^
      grandTotal.hashCode ^
      product.hashCode;


  @override
  String toString() {
    return 'CheckoutModel{voucherId: $voucherId, voucherAmount: $voucherAmount, '
        'point: $point, pointAmount: $pointAmount, deliveryFee: $deliveryFee, '
        'packaging: $packaging, taxAmount: $taxAmount, totalPrice: $totalPrice, '
        'totalDiscountPrice: $totalDiscountPrice, grandTotal: $grandTotal, '
        'productCount: ${product?.length ?? 0}}';
  }
}

class PaymentMethodModel {
  String? id;
  String? method;
  String? photo;
  String? description;
  PaymentMethodModel({this.id, this.method, this.photo, this.description});
  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    method = json['method'];
    photo = json['photo'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['method'] = method;
    data['photo'] = photo;
    data['description'] = description;
    return data;
  }
}



class Status {
  String? code;
  String? message;
  String? tranId;

  Status({this.code, this.message, this.tranId});

  Status.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    tranId = json['tran_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['tran_id'] = tranId;
    return data;
  }
}

class CheckTransactionModel {
  int? status;
  String? description;
  dynamic amount;
  dynamic totalAmount;
  String? apv;
  String? paymentStatus;
  String? datetime;
  CheckTransactionModel(
      {this.status,
      this.description,
      this.amount,
      this.totalAmount,
      this.apv,
      this.paymentStatus,
      this.datetime});
  CheckTransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] is int
        ? json['status']
        : int.tryParse(json['status']?.toString() ?? '0');
    description = json['description']?.toString();
    // Handle amount which could be string, double, or int
    if (json['amount'] != null) {
      if (json['amount'] is num) {
        amount = json['amount'];
      } else {
        amount = double.tryParse(json['amount'].toString()) ?? 0.0;
      }
    }
    // Handle totalAmount which could be string, double, or int
    if (json['totalAmount'] != null) {
      if (json['totalAmount'] is num) {
        totalAmount = json['totalAmount'];
      } else {
        totalAmount = double.tryParse(json['totalAmount'].toString()) ?? 0.0;
      }
    }
    apv = json['apv']?.toString();
    // Handle payment_status which might be in different formats
    if (json['payment_status'] != null) {
      paymentStatus = json['payment_status'].toString().toLowerCase();
    } else if (json['status'] is Map && json['status']['message'] != null) {
      // Handle nested status object
      paymentStatus = json['status']['message'].toString().toLowerCase();
    }

    datetime = json['datetime']?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['amount'] = amount;
    data['totalAmount'] = totalAmount;
    data['apv'] = apv;
    data['payment_status'] = paymentStatus;
    data['datetime'] = datetime;
    return data;
  }
}
