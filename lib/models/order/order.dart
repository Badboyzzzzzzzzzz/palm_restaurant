import 'package:palm_ecommerce_app/models/delivery.dart';
import 'package:palm_ecommerce_app/models/driver.dart';
import 'package:palm_ecommerce_app/models/product/product.dart';

class OrderModel {
  String? processStatusId;
  String? bookingId;
  String? processStatus;
  String? bookingDate;
  String? grandTotal;
  List<OrderPhoto> orderphoto = [];
  String? isPickUp;

  OrderModel({
    this.bookingId,
    this.processStatusId,
    this.processStatus,
    this.bookingDate,
    this.grandTotal,
    this.orderphoto = const [],
    this.isPickUp,
  });

  OrderModel.fromJson(Map<dynamic, dynamic> json) {
    bookingId = json['booking_id'];
    processStatusId = json['process_status_id'];
    processStatus = json['process_status'];
    bookingDate = json['booking_date'];
    grandTotal = json['grand_total'];
    if (json['Orderphoto'] != null) {
      orderphoto = <OrderPhoto>[];
      json['Orderphoto'].forEach((v) {
        orderphoto.add(OrderPhoto.fromJson(v));
      });
    }
    isPickUp = json['is_pick_up'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['process_status_id'] = processStatusId;
    data['process_status'] = processStatus;
    data['booking_date'] = bookingDate;
    data['grand_total'] = grandTotal;
    data['Orderphoto'] = orderphoto.map((v) => v.toJson()).toList();
    data['is_pick_up'] = isPickUp;
    return data;
  }
}

class OrderPhoto {
  String? bookingId;
  String? productId;
  String? photo;
  String? unitPrice;
  String? qty;
  String? productNameEn;
  bool isSelected = false;
  bool isRequestReturn = false;
  bool isReturn = false;

  OrderPhoto(
      {this.bookingId,
      this.productId,
      this.photo,
      this.unitPrice,
      this.qty,
      this.productNameEn,
      this.isSelected = false,
      this.isRequestReturn = false,
      this.isReturn = false});

  OrderPhoto.fromJson(Map<dynamic, dynamic> json) {
    bookingId = json['booking_id'];
    productId = json['product_id'];
    photo = json['photo'];
    unitPrice = json['unit_price'];
    qty = json['qty'];
    productNameEn = json['product_name_en'];
    isRequestReturn = json['is_request_return'] != null
        ? json['is_request_return'] == "1"
            ? true
            : false
        : false;
    isReturn = json['is_return'] != null
        ? json['is_return'] == "1"
            ? true
            : false
        : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['product_id'] = productId;
    data['photo'] = photo;
    data['unit_price'] = unitPrice;
    data['qty'] = qty;
    data['product_name_en'] = productNameEn;
    data['is_request_return'] = isRequestReturn;
    data['is_return'] = isReturn;
    return data;
  }
}

class OrderDetailModel {
  String? bookingId;
  String? bookingDate;
  String? packaging;
  String? packagingDescription;
  String? method;
  bool? isPickUp;
  String? addressId;
  int? processStatusId;
  String? voucherAmount;
  String? processStatus;
  String? deliveryFee;
  String? pointAmount;
  String? tax;
  String? discountAmount;
  String? grandTotal;
  String? adminNote;
  String? driverId;
  String? currency;
  DriverAddress? driver;
  List<TrackingStatusModel>? tracking;
  DeliveryAddressModel? deliveryAddress;
  int? count;
  List<OrderProductModel>? product;

  OrderDetailModel(
      {this.bookingId,
      this.bookingDate,
      this.method,
      this.isPickUp,
      this.addressId,
      this.processStatusId,
      this.voucherAmount,
      this.processStatus,
      this.deliveryFee,
      this.pointAmount,
      this.tax,
      this.discountAmount,
      this.grandTotal,
      this.adminNote,
      this.driverId,
      this.currency,
      this.driver,
      this.tracking,
      this.deliveryAddress,
      this.count,
      this.product});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id']?.toString() ?? '';
    bookingDate = json['booking_date']?.toString() ?? '';
    method = json['method']?.toString() ?? '';
    isPickUp = json['is_pick_up'] != null
        ? json['is_pick_up'] == "1"
            ? true
            : false
        : false;
    addressId = json['address_id']?.toString() ?? '';
    processStatusId = json['process_status_id'] != null
        ? int.parse(json['process_status_id'].toString())
        : 0;
    voucherAmount = json['voucher_amount']?.toString() ?? '';
    processStatus = json['process_status']?.toString() ?? '';
    deliveryFee = json['delivery_fee']?.toString() ?? '';
    pointAmount = json['point_amount']?.toString() ?? '';
    tax = json['tax']?.toString() ?? '';
    discountAmount = json['discount_amount']?.toString() ?? '';
    grandTotal = json['grand_total']?.toString() ?? '';
    adminNote = json['admin_note']?.toString() ?? '';
    driverId = json['driver_id']?.toString() ?? '';
    packaging = json['packaging']?.toString() ?? '';
    packagingDescription = json['packaging_description']?.toString() ?? '';
    currency = json['currency']?.toString() ?? '';
    driver =
        json['driver'] != null ? DriverAddress.fromJson(json['driver']) : null;
    if (json['tracking'] != null) {
      tracking = <TrackingStatusModel>[];
      json['tracking'].forEach((v) {
        tracking!.add(TrackingStatusModel.fromJson(v));
      });
    }

    deliveryAddress =
        json['deliveryAddress'] != null && json['deliveryAddress'] != ""
            ? DeliveryAddressModel.fromJson(json['deliveryAddress'])
            : null;

    count = json['count'] ?? 0;

    if (json['product'] != null) {
      product = <OrderProductModel>[];
      json['product'].forEach((v) {
        product!.add(OrderProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['booking_date'] = bookingDate;
    data['method'] = method;
    data['is_pick_up'] = isPickUp;
    data['address_id'] = addressId;
    data['process_status_id'] = processStatusId;
    data['voucher_amount'] = voucherAmount;
    data['process_status'] = processStatus;
    data['delivery_fee'] = deliveryFee;
    data['point_amount'] = pointAmount;
    data['tax'] = tax;
    data['discount_amount'] = discountAmount;
    data['grand_total'] = grandTotal;
    data['admin_note'] = adminNote;
    data['driver_id'] = driverId;
    data['currency'] = currency;
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    if (tracking != null) {
      data['tracking'] = tracking!.map((v) => v.toJson()).toList();
    }
    if (deliveryAddress != null) {
      data['deliveryAddress'] = deliveryAddress!.toJson();
    }
    data['count'] = count;
    if (product != null) {
      data['product'] = product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrackingStatusModel {
  String? statusProcessId;
  String? statusProcessEn;

  TrackingStatusModel({this.statusProcessId, this.statusProcessEn});

  TrackingStatusModel.fromJson(Map<String, dynamic> json) {
    statusProcessId = json['id'];
    statusProcessEn = json['status_process_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = statusProcessId;
    data['status_process_en'] = statusProcessEn;
    return data;
  }
}

class ProcessStatusModel {
  String id = "";
  String statusProcessEn = "";
  bool inorder = false;
  String? asset;

  ProcessStatusModel(
      {required this.id,
      required this.statusProcessEn,
      required this.inorder,
      this.asset});
  ProcessStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statusProcessEn = json['status_process_en'];
    inorder = json['inorder'];
    asset = json['asset'];
  }
}
