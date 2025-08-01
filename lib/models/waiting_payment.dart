class WaitingPayment {
  String? bookingId;
  String? processStatusId;
  String? processStatus;
  String? bookingDate;
  String? grandTotal;
  List<Orderphoto>? orderphoto;

  WaitingPayment(
      {this.bookingId,
        this.processStatusId,
        this.processStatus,
        this.bookingDate,
        this.grandTotal,
        this.orderphoto});

  WaitingPayment.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    processStatusId = json['process_status_id'];
    processStatus = json['process_status'];
    bookingDate = json['booking_date'];
    grandTotal = json['grand_total'];
    if (json['Orderphoto'] != null) {
      orderphoto = <Orderphoto>[];
      json['Orderphoto'].forEach((v) {
        orderphoto!.add(Orderphoto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['process_status_id'] = processStatusId;
    data['process_status'] = processStatus;
    data['booking_date'] = bookingDate;
    data['grand_total'] = grandTotal;
    if (orderphoto != null) {
      data['Orderphoto'] = orderphoto!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orderphoto {
  String? bookingId;
  String? productId;
  String? productNameEn;
  String? qty;
  String? unitPrice;
  String? createdAt;
  String? photo;

  Orderphoto(
      {this.bookingId,
        this.productId,
        this.productNameEn,
        this.qty,
        this.unitPrice,
        this.createdAt,
        this.photo});

  Orderphoto.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    productId = json['product_id'];
    productNameEn = json['product_name_en'];
    qty = json['qty'];
    unitPrice = json['unit_price'];
    createdAt = json['created_at'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['product_id'] = productId;
    data['product_name_en'] = productNameEn;
    data['qty'] = qty;
    data['unit_price'] = unitPrice;
    data['created_at'] = createdAt;
    data['photo'] = photo;
    return data;
  }
}
