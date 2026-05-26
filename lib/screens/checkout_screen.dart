import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/cart_service.dart';
import '../../routes/app_routes.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  int selectedPayment = 0; // 0 = Card, 1 = COD

  @override
  Widget build(BuildContext context) {

    final cartService = CartService.instance;
    final items = cartService.cartItems;

    double subtotal = cartService.totalPrice;
    double shipping = 0;
    double tax = subtotal * 0.10;
    double total = subtotal + tax + shipping;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // ✅ PRODUCTS (UNCHANGED UI)
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {

                  final item = items[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),

                    child: Row(
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item['imageUrl'] ?? '',
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                item['name'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text("Qty:${item['quantity']}"),
                            ],
                          ),
                        ),

                        Text(
                          "Rs.\n${item['price']}",
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Divider(),

            // ✅ PRICE DETAILS (UNCHANGED)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal"),
                Text("Rs. ${subtotal.toStringAsFixed(2)}"),
              ],
            ),

            const SizedBox(height: 8),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Shipping"),
                Text("Free"),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tax (10%)"),
                Text("Rs. ${tax.toStringAsFixed(2)}"),
              ],
            ),

            const SizedBox(height: 16),

            // ✅ ✅ NEW PAYMENT SECTION (CLEAN DESIGN)
            const Text(
              "Payment Method",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            RadioListTile(
              value: 0,
              groupValue: selectedPayment,
              title: const Text("Credit / Debit Card"),
              onChanged: (value) {
                setState(() {
                  selectedPayment = value!;
                });
              },
            ),

            RadioListTile(
              value: 1,
              groupValue: selectedPayment,
              title: const Text("Cash on Delivery"),
              onChanged: (value) {
                setState(() {
                  selectedPayment = value!;
                });
              },
            ),

            const SizedBox(height: 10),

            const Divider(),

            // ✅ TOTAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "TOTAL",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rs. ${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ✅ PLACE ORDER (FUNCTIONAL)
            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please login to place order'),
                      ),
                    );
                    return;
                  }

                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('orders')
                        .add({
                      'items': items,
                      'subtotal': subtotal,
                      'tax': tax,
                      'total': total,
                      'paymentMethod':
                          selectedPayment == 0 ? 'Card' : 'COD',
                      'timestamp': FieldValue.serverTimestamp(),
                    });

                    cartService.clearCart();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order placed successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.home, (route) => false);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },

                child: const Text(
                  "PLACE ORDER →",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}