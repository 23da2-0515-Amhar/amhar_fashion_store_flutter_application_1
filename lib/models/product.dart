class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromFirestore(Map<String, dynamic> data) {
    return Product(
      name: data['name'] ?? '',

      // ✅ FIXED (IMPORTANT)
      price: (data['price'] as num?)?.toDouble() ?? 0.0,

      imageUrl: data['imageUrl'] ?? '',
    );
  }
}