import 'package:flutter/material.dart';
import '../../services/cart_service.dart';
import '../../routes/app_routes.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  final CartService cartService = CartService.instance;

  @override
  Widget build(BuildContext context) {

    final items = cartService.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
      ),

      body: items.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
              children: [

                // ✅ LIST
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,

                    itemBuilder: (context, index) {

                      final item = items[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // ✅ IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                item['imageUrl'] ?? '',
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 16),

                            // ✅ DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    item['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    "Rs. ${item['price']}",
                                    style: const TextStyle(fontSize: 16),
                                  ),

                                  const SizedBox(height: 12),

                                  // ✅ QUANTITY CONTROL
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              cartService.decreaseQty(index);
                                            });
                                          },
                                          icon: const Icon(Icons.remove),
                                        ),

                                        Text("${item['quantity']}"),

                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              cartService.increaseQty(index);
                                            });
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ✅ DELETE ICON
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 28,
                              ),
                              onPressed: () {
                                setState(() {
                                  cartService.removeItem(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ✅ BOTTOM SECTION
                Container(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [

                      const Divider(),

                      const SizedBox(height: 10),

                      // ✅ TOTAL
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [

                          const Text(
                            "Total",
                            style: TextStyle(fontSize: 18),
                          ),

                          Text(
                            "Rs. ${cartService.totalPrice.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ✅ CHECKOUT BUTTON
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

                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.checkout,
                            );
                          },

                          child: const Text(
                            "CHECKOUT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
