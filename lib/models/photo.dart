class Photo {
  String? id;
  String? photo;

  Photo({this.photo, this.id});

  // Constructor that takes an image path
  Photo.fromPath(String imagePath) {
    photo = imagePath;
  }

  Photo.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    id = json['id'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['id'] = id;
    return data;
  }
}
