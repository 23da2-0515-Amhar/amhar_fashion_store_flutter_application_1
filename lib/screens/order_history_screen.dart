import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),

      body: StreamBuilder<QuerySnapshot>(
        // ✅ USER-SPECIFIC ORDERS
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(child: Text("No orders"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,

            itemBuilder: (context, index) {

              final order =
                  orders[index].data() as Map<String, dynamic>;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Order ${index + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 10),

                      ...((order['items'] ?? []) as List).map((item) {
                        return ListTile(
                          leading: Image.network(
                            item['imageUrl'] ?? '',
                            width: 40,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image),
                          ),
                          title: Text(item['name'] ?? ''),
                          subtitle: Text(
                              "Rs. ${item['price']}"),
                        );
                      }),

                      const SizedBox(height: 10),

                      Text(
                        "Total: Rs. ${order['total'] ?? 0}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}