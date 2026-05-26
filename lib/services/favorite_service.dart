class FavoriteService {
  // Singleton
  static final FavoriteService instance = FavoriteService._internal();
  FavoriteService._internal();

  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  // Check if product is favorite
  bool isFavorite(String name) {
    return _favorites.any((item) => item['name'] == name);
  }

  void addFavorite(Map<String, dynamic> product) {
    if (!isFavorite(product['name'])) {
      _favorites.add(product);
    }
  }

  // Remove from favorites
  void removeFavorite(String name) {
    _favorites.removeWhere((item) => item['name'] == name);
  }

  void clearFavorites() {
    _favorites.clear();
  }
}
