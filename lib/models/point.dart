class PointExchangeModel {
  Exchange? exchange;
  List<ExchangeAmount>? data;

  PointExchangeModel({this.exchange, this.data});

  PointExchangeModel.fromJson(Map<String, dynamic> json) {
    exchange = json['exchange'] != null
        ? Exchange.fromJson(json['exchange'])
        : null;
    if (json['data'] != null) {
      data = <ExchangeAmount>[];
      json['data'].forEach((v) {
        data!.add(ExchangeAmount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (exchange != null) {
      data['exchange'] = exchange!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Exchange {
  int? point;
  double? uSA;

  Exchange({this.point, this.uSA});

  Exchange.fromJson(Map<String, dynamic> json) {
    point = json['point'];
    uSA = json['USA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['point'] = point;
    data['USA'] = uSA;
    return data;
  }
}

class ExchangeAmount {
  String? id;
  String? point;
  int? usdAmount;

  ExchangeAmount({this.id, this.point, this.usdAmount});

  ExchangeAmount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    point = json['point'];
    usdAmount = json['usd_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['point'] = point;
    data['usd_amount'] = usdAmount;
    return data;
  }
}
