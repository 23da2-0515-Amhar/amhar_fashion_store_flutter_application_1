import 'package:flutter/material.dart';
import '../../services/cart_service.dart';
import '../../services/favorite_service.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  final CartService cartService = CartService.instance;
  final FavoriteService favoriteService = FavoriteService.instance;

  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic> product =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final bool isFav = favoriteService.isFavorite(product['name']);

    final double price = product['price'] is String
        ? double.parse(product['price'].replaceAll('Rs. ', '').trim())
        : product['price'];

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'Product Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        centerTitle: true,

        // ❤️ Favorite
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              setState(() {
                if (isFav) {
                  favoriteService.removeFavorite(product['name']);
                } else {
                  favoriteService.addFavorite({
                    'name': product['name'],
                    'price': price,
                    'imageUrl': product['imageUrl'], // ✅ FIXED
                  });
                }
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFav
                        ? 'Removed from favorites'
                        : 'Added to favorites',
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ✅ IMAGE FROM FIREBASE
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                product['imageUrl'],
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // 🏷 NAME
            Text(
              product['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // 💰 PRICE
            Text(
              'Rs. ${price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 📝 DESCRIPTION
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'This premium fashion item is crafted with high‑quality materials, '
              'offering durability, comfort, and a modern silhouette.',
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),

            const SizedBox(height: 30),

            // 🛒 ADD TO CART
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                onPressed: () {
                  cartService.addToCart({
                    'name': product['name'],
                    'price': price,
                    'imageUrl': product['imageUrl'], // ✅ FIXED
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product added to cart'),
                    ),
                  );
                },

                child: const Text(
                  'ADD TO CART',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}