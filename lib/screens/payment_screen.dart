import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  final cardController = TextEditingController();
  final nameController = TextEditingController();
  final expiryController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  Future<void> savePayment() async {

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('payments') // ✅ USER-SPECIFIC
        .add({
      'cardNumber': cardController.text,
      'name': nameController.text,
      'expiry': expiryController.text,
      'timestamp': DateTime.now(),
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment saved")),
    );
  }

  void openForm() {
    cardController.clear();
    nameController.clear();
    expiryController.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Payment"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: cardController, decoration: const InputDecoration(labelText: "Card Number")),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Card Holder Name")),
              TextField(controller: expiryController, decoration: const InputDecoration(labelText: "Expiry Date")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: savePayment, child: const Text("Save")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Payment Methods")),
      floatingActionButton: FloatingActionButton(
        onPressed: openForm,
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('payments') // ✅ USER FILTER
            .orderBy('timestamp', descending: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No payment methods"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {

              final data = docs[index].data() as Map<String, dynamic>;

              final card = data['cardNumber'] ?? '';
              final last4 = card.length >= 4
                  ? card.substring(card.length - 4)
                  : card;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: Text("**** **** **** $last4"),
                  subtitle: Text("${data['name']} - ${data['expiry']}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}