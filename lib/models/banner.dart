class BannerModel {
  String? id;
  String? title;
  String? bannerType;
  String? action;
  String? photo;
  String? status;

  BannerModel(
      {this.id,
        this.title,
        this.bannerType,
        this.action,
        this.photo,
        this.status});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    bannerType = json['banner_type'];
    action = json['action'];
    photo = json['photo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['banner_type'] = this.bannerType;
    data['action'] = this.action;
    data['photo'] = this.photo;
    data['status'] = this.status;
    return data;
  }
}
