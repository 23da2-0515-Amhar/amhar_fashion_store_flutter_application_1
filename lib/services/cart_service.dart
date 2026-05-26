import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  // ✅ Singleton pattern
  static final CartService instance = CartService._internal();
  CartService._internal();

  // ✅ Internal cart storage
  final List<Map<String, dynamic>> _cartItems = [];

  // ✅ Public getter
  List<Map<String, dynamic>> get cartItems => _cartItems;

  // ✅ Add product to cart (PRICE ALWAYS DOUBLE ✅)
  void addToCart(Map<String, dynamic> product) {
    final double price = product['price'] is String
        ? double.parse(
            product['price'].toString().replaceAll('Rs.', '').trim(),
          )
        : (product['price'] as num).toDouble();

    final int index =
        _cartItems.indexWhere((item) => item['name'] == product['name']);

    if (index >= 0) {
      _cartItems[index]['quantity'] += 1;
    } else {
      _cartItems.add({
        'name': product['name'],
        'price': price,
        'imageUrl': product['imageUrl'] ?? product['image'] ?? '',
        'quantity': 1,
      });
    }

    _saveCart();
  }

  // ➕ Increase quantity
  void increaseQty(int index) {
    _cartItems[index]['quantity'] += 1;
    _saveCart();
  }

  // ➖ Decrease quantity (min = 1)
  void decreaseQty(int index) {
    if (_cartItems[index]['quantity'] > 1) {
      _cartItems[index]['quantity'] -= 1;
      _saveCart();
    }
  }

  // ❌ Remove item
  void removeItem(int index) {
    _cartItems.removeAt(index);
    _saveCart();
  }

  // 🧹 Clear cart (used after checkout)
  void clearCart() {
    _cartItems.clear();
    _saveCart();
  }

  // 🛠 Load cart from Firestore for current user
  Future<void> loadCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) return;

    final data = doc.data();
    if (data == null) return;

    final cartData = data['cart'] as List<dynamic>?;
    if (cartData == null) return;

    _cartItems
      ..clear()
      ..addAll(cartData.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return {
          'name': map['name'],
          'price': map['price'] is num
              ? (map['price'] as num).toDouble()
              : double.tryParse(map['price'].toString()) ?? 0.0,
          'imageUrl': map['imageUrl'] ?? map['image'] ?? '',
          'quantity': map['quantity'] ?? 1,
        };
      }));
  }

  Future<void> _saveCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'cart': _cartItems,
        },
        SetOptions(merge: true),
      );
    } catch (_) {
      // Ignore save failures; local cart is still available.
    }
  }

  // 💰 Total price (SAFE ✅)
  double get totalPrice {
    double total = 0.0;
    for (final item in _cartItems) {
      total += (item['price'] as double) * (item['quantity'] as int);
    }
    return total;
  }
}
