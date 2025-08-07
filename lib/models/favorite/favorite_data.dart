import 'package:palm_ecommerce_app/models/favorite/favourite.dart';

class FavouriteData {
  int? currentPage;
  List<FavouriteModel>? data;
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

  FavouriteData(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavouriteData &&
        other.currentPage == currentPage &&
        other.data == data &&
        other.firstPageUrl == firstPageUrl &&
        other.from == from &&
        other.lastPage == lastPage &&
        other.lastPageUrl == lastPageUrl &&
        other.nextPageUrl == nextPageUrl &&
        other.path == path &&
        other.perPage == perPage &&
        other.prevPageUrl == prevPageUrl &&
        other.to == to &&
        other.total == total;
  }

  @override
  int get hashCode =>
      currentPage.hashCode ^
      data.hashCode ^
      firstPageUrl.hashCode ^
      from.hashCode ^
      lastPage.hashCode ^
      lastPageUrl.hashCode ^
      nextPageUrl.hashCode ^
      path.hashCode ^
      perPage.hashCode ^
      prevPageUrl.hashCode ^
      to.hashCode ^
      total.hashCode;
}
