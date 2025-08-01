class NotificationModel {
  int? currentPage;
  List<NotificationData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  NotificationModel(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});
  NotificationModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class NotificationData {
  String? id;
  String? isView;
  String? title;
  String? description;
  String? pionter;
  String? productId;
  String? orderId;
  String? date;
  String? time;
  String? isPin;
  String? photo;

  NotificationData(
      {this.id,
        this.isView,
        this.title,
        this.description,
        this.pionter,
        this.productId,
        this.orderId,
        this.date,
        this.time,
        this.isPin,
        this.photo});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isView = json['is_view'];
    title = json['title'];
    description = json['description'];
    pionter = json['pionter'];
    productId = json['product_id'];
    orderId = json['order_id'];
    date = json['date'];
    time = json['time'];
    isPin = json['is_pin'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_view'] = isView;
    data['title'] = title;
    data['description'] = description;
    data['pionter'] = pionter;
    data['product_id'] = productId;
    data['order_id'] = orderId;
    data['date'] = date;
    data['time'] = time;
    data['is_pin'] = isPin;
    data['photo'] = photo;
    return data;
  }
}
