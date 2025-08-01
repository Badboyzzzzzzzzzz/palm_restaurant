import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/data/repository/favorite_repository.dart';
import 'package:palm_ecommerce_app/models/favorite/favourite.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRepository favoriteRepository;
  FavoriteProvider(this.favoriteRepository);

  AsyncValue<FavouriteResponse> _favoriteProducts = AsyncValue.empty();
  AsyncValue<FavouriteResponse> get favoriteProducts => _favoriteProducts;

  String? _lastError;
  String? get lastError => _lastError;
  final Set<String> _recentlyToggledProductIds = {};
  Set<String> get recentlyToggledProductIds => _recentlyToggledProductIds;

  // Add a set to track locally favorited products for immediate UI updates
  final Set<String> _localFavorites = {};
  Set<String> get localFavorites => _localFavorites;

  Future<void> addToFavorite(String productId) async {
    try {
      _localFavorites.add(productId);
      _recentlyToggledProductIds.add(productId);
      notifyListeners();
      await favoriteRepository.addToFavorites(productId: productId);
      await _updateFavoriteProductsSilently();
    } catch (e) {
      _lastError = e.toString();
      _localFavorites.remove(productId);
      _recentlyToggledProductIds.remove(productId);
      notifyListeners();
    }
  }

  Future<void> _updateFavoriteProductsSilently() async {
    try {
      final favoriteProducts = await favoriteRepository.getFavoriteProducts();
      _favoriteProducts = AsyncValue.success(favoriteProducts);
      _recentlyToggledProductIds.clear();
    } catch (e) {
      _favoriteProducts = AsyncValue.error(e);
      notifyListeners();
    }
  }

  Future<void> getFavoriteProducts() async {
    _favoriteProducts = AsyncValue.loading();
    notifyListeners();
    try {
      final favoriteProducts = await favoriteRepository.getFavoriteProducts();
      _favoriteProducts = AsyncValue.success(favoriteProducts);
      _recentlyToggledProductIds.clear();
      _localFavorites.clear();
      if (favoriteProducts.data?.data != null) {
        for (var item in favoriteProducts.data!.data!) {
          if (item.productId != null) {
            _localFavorites.add(item.productId!);
          }
        }
      }
      notifyListeners();
    } catch (e) {
      _favoriteProducts = AsyncValue.error(e);
      notifyListeners();
    }
  }
  // Helper method to check if a product is in favorites
  bool isProductFavorited(String productId) {
    // First check local favorites for immediate response
    if (_localFavorites.contains(productId)) return true;
    // Fallback to server data
    final favorites = _favoriteProducts.data?.data?.data;
    if (favorites == null || favorites.isEmpty) return false;
    return favorites.any((item) => item.productId == productId);
  }
}
