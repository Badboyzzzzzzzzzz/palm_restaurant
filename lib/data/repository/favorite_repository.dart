import 'package:palm_ecommerce_app/models/favorite/favorite_response.dart';
import 'package:palm_ecommerce_app/models/favorite/favourite.dart';

abstract class FavoriteRepository {
  Future<FavouriteModel> addToFavorites({
    required String productId,
  });
  Future<FavouriteResponse> getFavoriteProducts();
}
