class Onboarding {
  String? id;
  String? titleEn;
  String? descriptionEn;
  String? photo;
  String? isVideo;

  Onboarding(
      {this.id, this.titleEn, this.descriptionEn, this.photo, this.isVideo});

  Onboarding.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleEn = json['title_en'];
    descriptionEn = json['description_en'];
    photo = json['photo'];
    isVideo = json['is_video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title_en'] = titleEn;
    data['description_en'] = descriptionEn;
    data['photo'] = photo;
    data['is_video'] = isVideo;
    return data;
  }
}
