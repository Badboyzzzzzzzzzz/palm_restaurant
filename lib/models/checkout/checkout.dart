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

  CheckoutModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert any value to String
    String? toStringValue(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    voucherId = toStringValue(json['voucher_id']);
    voucherAmount = toStringValue(json['voucher_amount']);
    point = toStringValue(json['point']);
    pointAmount = toStringValue(json['point_amount']);
    deliveryFee = toStringValue(json['delivery_fee']);
    packaging = toStringValue(json['packaging']);
    packagingDescription = toStringValue(json['packaging_description']);
    taxAmount = toStringValue(json['tax_amount']);
    totalPrice = toStringValue(json['total_price']);
    totalDiscountPrice = toStringValue(json['total_discount_price']);
    totalPriceOfterDiscount = toStringValue(json['total_price_ofter_discount']);
    grandTotal = toStringValue(json['grand_total']);
    if (json['product'] != null) {
      product = <CheckoutProduct>[];
      json['product'].forEach((v) {
        product!.add(CheckoutProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['voucher_id'] = voucherId;
    data['voucher_amount'] = voucherAmount;
    data['point'] = point;
    data['point_amount'] = pointAmount;
    data['delivery_fee'] = deliveryFee;
    data['packaging'] = packaging;
    data['packaging_description'] = packagingDescription;
    data['tax_amount'] = taxAmount;
    data['total_price'] = totalPrice;
    data['total_discount_price'] = totalDiscountPrice;
    data['total_price_ofter_discount'] = totalPriceOfterDiscount;
    data['grand_total'] = grandTotal;
    if (product != null) {
      data['product'] = product!.map((v) => v.toJson()).toList();
    }
    return data;
  }

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

class CheckoutABAModel {
  Status? status;
  String? description;
  String? qrString;
  String? abapayDeeplink;
  String? checkoutQrUrl;
  int? lifetime;
  String? currency;

  CheckoutABAModel({
    this.status,
    this.description,
    this.qrString,
    this.abapayDeeplink,
    this.checkoutQrUrl,
    this.lifetime,
    this.currency,
  });

  CheckoutABAModel.fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'] != null ? Status.fromJson(json['status']) : null;

      // Helper function to safely convert any value to String
      String? toStringValue(dynamic value) {
        if (value == null) return null;
        return value.toString();
      }

      // Safely convert all string fields
      description = toStringValue(json['description']);
      qrString = toStringValue(json['qr_string']);
      abapayDeeplink = toStringValue(json['abapay_deeplink']);
      checkoutQrUrl = toStringValue(json['checkout_qr_url']);

      // Handle lifetime which could be int or string
      if (json['lifetime'] != null) {
        if (json['lifetime'] is int) {
          lifetime = json['lifetime'];
        } else {
          // Convert to string first, then parse as int with fallback
          lifetime = int.tryParse(json['lifetime'].toString()) ?? 180;
        }
      } else {
        lifetime = 180; // Default value
      }

      currency = toStringValue(json['currency']);
    } catch (e) {
      print("Error in CheckoutABAModel.fromJson: $e");
      // Set default values on error
      description = "Error parsing data";
      lifetime = 180;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['description'] = description;
    data['qr_string'] = qrString;
    data['abapay_deeplink'] = abapayDeeplink;
    data['checkout_qr_url'] = checkoutQrUrl;
    data['lifetime'] = lifetime;
    data['currency'] = currency;
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

  CheckoutProduct.fromJson(Map<String, dynamic> json) {
    String? toStringValue(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    id = toStringValue(json['id']);
    productId = toStringValue(json['product_id']);
    qty = toStringValue(json['qty']);
    price = toStringValue(json['price']);
    photo = toStringValue(json['photo']);
    productNameEn = toStringValue(json['product_name_en']);
    priceBeforeDiscount = toStringValue(json['price_before_discount']);
    amount = toStringValue(json['amount']);
    color = toStringValue(json['color']);
    size = toStringValue(json['size']);
    description = toStringValue(json['description']);
    packagingID = toStringValue(json['packaging_id']);
    packageNote = toStringValue(json['packaging_note']);
    packageQTY = toStringValue(json['packaging_qty']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['qty'] = qty;
    data['price'] = price;
    data['photo'] = photo;
    data['product_name_en'] = productNameEn;
    data['price_before_discount'] = priceBeforeDiscount;
    data['amount'] = amount;
    data['color'] = color;
    data['size'] = size;
    data['description'] = description;
    data['packaging_id'] = packagingID;
    data['packaging_note'] = packageNote;
    data['packaging_qty'] = packageQTY;
    return data;
  }
}
