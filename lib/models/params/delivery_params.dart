import 'package:image_picker/image_picker.dart';

class DeliveryParams {
  String latitude;
  String longitude;
  String address;
  String addressType;
  List<XFile> photos = [];
  String phone;
  String fullName;

  DeliveryParams({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.addressType,
    required this.photos,
    required this.phone,
    required this.fullName,
  });

  factory DeliveryParams.fromJson(Map<String, dynamic> json) => DeliveryParams(
    latitude: json['latitude'],
    longitude: json['longitude'],
    address: json['address'],
    addressType: json['address_type'],
    photos: List<XFile>.from(json['photo'].map((x) => XFile(x))),
    phone: json['phone'],
    fullName: json['full_name'],
  );

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'address_type': addressType,
    'photo': List<dynamic>.from(photos.map((x) => x.path)),
    'phone': phone,
    'full_name': fullName,
  };
}