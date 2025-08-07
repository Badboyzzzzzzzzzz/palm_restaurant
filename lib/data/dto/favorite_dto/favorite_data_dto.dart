import 'package:palm_ecommerce_app/data/dto/favorite_dto/favorite_dto.dart';
import 'package:palm_ecommerce_app/models/favorite/favorite_data.dart';
import 'package:palm_ecommerce_app/models/favorite/favourite.dart';

class FavoriteDataDto {
  static FavouriteData fromJson(Map<String, dynamic> json) {
    List<FavouriteModel>? data;
    if (json['data'] != null) {
      data = <FavouriteModel>[];
      json['data'].forEach((v) {
        data!.add(FavoriteDto.fromJson(v));
      });
    }
    return FavouriteData(
      currentPage: json['current_page'],
      data: data,
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }

  static Map<String, dynamic> toJson(FavouriteData favor) {
    final Map<String, dynamic> data = {};
    data['current_page'] = favor.currentPage;
    if (favor.data != null) {
      data['data'] = favor.data!.map((v) => FavoriteDto.toJson(v)).toList();
    }
    data['first_page_url'] = favor.firstPageUrl;
    data['from'] = favor.from;
    data['last_page'] = favor.lastPage;
    data['last_page_url'] = favor.lastPageUrl;
    data['next_page_url'] = favor.nextPageUrl;
    data['path'] = favor.path;
    data['per_page'] = favor.perPage;
    data['prev_page_url'] = favor.prevPageUrl;
    data['to'] = favor.to;
    data['total'] = favor.total;
    return data;
  }
}
