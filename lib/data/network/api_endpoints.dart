class ApiConstant {
  // Auth Endpoints
  static const String login = 'api/login';
  static const String register = 'api/register';
  static const String sendOtp = 'api/resend-code';
  static const String verifyOtp = 'api/verify-phone';
  static const String resetPassword = '/api/reset-password/';
  static const String changePassword = '/api/change-password';
  static const String getUserInfo = 'api/user-info';
  static const String googleSignIn = '/api/login-with-social-media';
  static const String updateProfile = '/api/update-profile';

  // Product Endpoints
  static const String products = '/api/get-child-category/PALM-0006';
  static const String superHotPromotion =
      '/api/get-product-super-hot-promotion/PALM-00060001/PALM-0006/';
  static const String newArrivalProduct =
      '/api/get-product-new-arrive/PALM-00060001/PALM-0006/';
  static const String searchFoodDishes = '/api/search-product';
  static const String bannerSlideShow = '/api/get-banner/PALM-0006';
  static const String getRelateFood = 'api/product-related';
  // Category Endpoints
  static const String mainCategory = '/api/get-main-category/PALM-0006';
  static const String subCategories = '/api/get-sub-category/PALM-0006';
  static const String getProductsBySubCategory =
      '/api/get-product-by-sub-category';
  // Cart Endpoints
  static const String getCart = '/api/get-cart/';
  static const String addToCart = 'api/add_to_cart';
  static const String updateCartItem = '/api/update-cart-qty';
  static const String removeCartItem = '/api/update-cart-delete';
  static const String clearCart = '/api/clear-cart';

  // Checkout Endpoints
  static const String checkout = '/api/check-out';
  static const String checkoutInfo = '/api/get-check-out-info';

  // User Location Endpoints
  static const String setUserLocation = '/api/add-location';
  static const String getUserLocation = '/api/get-user-location';
  static const String updateUserLocation = '/api/update-location';
  static const String deleteUserLocation = '/api/delete-location';

  // Favorite Endpoints
  static const String addToFavorite = '/api/set-to-favourite';
  static const String getFavoriteProducts = '/api/get-favourited';
  static const String removeFromFavorite = '/api/remove-favourite/';

  // Order Endpoints
  static const String getOrders = '/api/my-order/';
  static const String reviewProduct = '/api/review-product';
  static const String cancelOrder = '/api/cancel-order';
  static const String orderDetail = '/api/order-detail';
  static const String orderList = '/api/get-order-list/';
  static const String orderListByStatus = '/api/list-process-status/';

  // Payment Method Endpoints
  static const String paymentMethod = '/api/method-paymant-list';
  static const String getKhqrDeeplink = '/api/get-khqr-deeplink';
  static const String waitingForPayment = '/api/waiting-for-payment';
  static const String checkTransaction = '/api/check-transaction/';
  static const String verifyBakongPayment =
      'https://api-bakong.nbc.gov.kh/v1/check_transaction_by_md5';
  // Updated token with current validity period
  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7ImlkIjoiYjlhZmQxYzUxMTNmNDBiNiJ9LCJpYXQiOjE3NTMwNjY3NTksImV4cCI6MTc2MDg0Mjc1OX0.dVKuBXVfi1HJ9lnw9h2UYszRUn69Sl1GXtM8-64QUiI';

  // Notification Endpoints
  static const String getNotification = '/api/get-all-notification';
}
