import 'package:flutter/material.dart';
import '../../services/favorite_service.dart';
import '../../routes/app_routes.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  final FavoriteService favoriteService = FavoriteService.instance;

  @override
  Widget build(BuildContext context) {

    final favorites = favoriteService.favorites;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).iconTheme.color,
        ),
      ),

      body: favorites.isEmpty
          ? _emptyFavorites()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return _favoriteItem(item);
              },
            ),
    );
  }

  Widget _favoriteItem(Map<String, dynamic> item) {

    final String imageUrl = item['imageUrl'] ?? "";

    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        // ✅ IMAGE
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,

            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const SizedBox(
                width: 60,
                height: 60,
                child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2)),
              );
            },

            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image),
              );
            },
          ),
        ),

        // ✅ TITLE
        title: Text(
          item['name'] ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),

        // ✅ PRICE
        subtitle: Text(
          'Rs. ${(item['price'] ?? 0).toString()}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),

        // ✅ FAVORITE ICON (kept red ✅)
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            setState(() {
              favoriteService.removeFavorite(item['name']);
            });
          },
        ),

        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.product,
            arguments: {
              'name': item['name'],
              'price': item['price'],
              'imageUrl': item['imageUrl'],
            },
          );
        },
      ),
    );
  }

  Widget _emptyFavorites() {
    return Center(
      child: Text(
        'No favorites added yet',
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}
