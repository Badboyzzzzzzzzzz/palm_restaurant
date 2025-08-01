import 'package:palm_ecommerce_app/models/photo.dart';
import 'package:image_picker/image_picker.dart';

class DeliveryAddressModel {
  String? id;
  String? address;
  String? latitude;
  String? longitude;
  String? addressTypeId;
  String? fullName;
  String? phone;
  String? description;
  List<Photo>? photo;
  AddressType? addressType;
  bool isActive = false;

  DeliveryAddressModel(
      {this.id,
      this.address,
      this.latitude,
      this.longitude,
      this.addressTypeId,
      this.fullName,
      this.phone,
      this.description,
      this.photo,
      this.addressType});

  DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    // Safe null checking for fields that exist in JSON
    id = json['id']?.toString() ?? '';
    address = json['address']?.toString() ?? '';
    latitude = json['latitude']?.toString() ?? '';
    longitude = json['longitude']?.toString() ?? '';
    phone = json['phone']?.toString() ?? '';

    // Safe null checking for fields that might not exist in JSON
    addressTypeId = json['address_type_id']?.toString() ?? '';
    fullName = json['full_name']?.toString() ?? '';
    description = json['description']?.toString() ?? '';

    // Handle photo array safely
    if (json['photo'] != null) {
      photo = <Photo>[];
      json['photo'].forEach((v) {
        photo!.add(Photo.fromJson(v));
      });
    } else {
      photo = null; // or initialize as empty list: photo = <Photo>[];
    }

    // Handle nested object safely
    addressType = json['address_type'] != null
        ? AddressType.fromJson(json['address_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address_type'] = addressType;
    data['full_name'] = fullName;
    data['phone'] = phone;
    data['description'] = description;
    if (photo != null) {
      data['photo'] = photo!.map((v) => v.toJson()).toList();
    }
    if (addressType != null) {
      data['address_type'] = addressType!.toJson();
    }
    return data;
  }
}

class AddressType {
  String? id;
  String? addressType;
  String? photo;

  AddressType({this.id, this.addressType, this.photo});

  AddressType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address_type'] = addressType;
    data['photo'] = photo;
    return data;
  }
}

class ImageAddress {
  XFile image;
  String id;
  ImageAddress({required this.image, required this.id});
}

class AddressTypeModel {
  String? id;
  String? addressType;
  String? photo;
  String? photoW;

  AddressTypeModel({
    this.id,
    this.addressType,
    this.photo,
    this.photoW,
  });

  AddressTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    photo = json['photo'];
    photoW = json['photo_w'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address_type'] = addressType;
    data['photo'] = photo;
    data['photo_w'] = photoW;
    return data;
  }
}

class StandardDelivery {
  String? price;
  String? note;
  String? branch;

  StandardDelivery({this.price, this.note, this.branch});

  StandardDelivery.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    note = json['note'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['note'] = note;
    data['branch'] = branch;
    return data;
  }
}
