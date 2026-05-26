import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../routes/app_routes.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // ✅ REMOVE CATEGORY FILTER (no argument needed)

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"), // ✅ fixed title
      ),

      body: StreamBuilder<QuerySnapshot>(
        // ✅ SHOW ALL PRODUCTS
        stream: FirebaseFirestore.instance
            .collection('products')
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),

            itemBuilder: (context, index) {

              final product =
                  docs[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.product,
                    arguments: product,
                  );
                },

                child: Card(
                  child: Column(
                    children: [

                      Expanded(
                        child: Image.network(
                          product['imageUrl'] ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),

                      Text(product['name'] ?? ''),
                      Text("Rs. ${product['price'] ?? 0}"),
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