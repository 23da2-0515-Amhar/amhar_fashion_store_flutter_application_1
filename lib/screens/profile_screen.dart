import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String userName = "Amhar";
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // ✅ LOAD USER DATA
  void loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        userName = doc['name'] ?? "Amhar";
        imageUrl = doc['image'] ?? "";
      });
    }
  }

  // ✅ SAVE NAME
  void saveName(String name) async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .set({'name': name}, SetOptions(merge: true));

    setState(() {
      userName = name;
    });
  }

  // ✅ PICK IMAGE + UPLOAD
  Future<void> pickImage() async {

    final user = FirebaseAuth.instance.currentUser;
    final picker = ImagePicker();

    final picked =
        await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {

      File file = File(picked.path);

      final ref = FirebaseStorage.instance
          .ref('profile_images/${user!.uid}.jpg');

      await ref.putFile(file);

      String url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'image': url}, SetOptions(merge: true));

      setState(() {
        imageUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),

      body: Column(
        children: [

          const SizedBox(height: 30),

          // ✅ PROFILE IMAGE
          Stack(
            children: [

              CircleAvatar(
                radius: 60,
                backgroundImage:
                    imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                child: imageUrl.isEmpty
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ✅ NAME EDIT
          GestureDetector(
            onTap: () {
              final controller =
                  TextEditingController(text: userName);

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Edit Name"),
                  content: TextField(controller: controller),
                  actions: [
                    TextButton(
                        onPressed: () {
                          saveName(controller.text);
                          Navigator.pop(context);
                        },
                        child: const Text("Save"))
                  ],
                ),
              );
            },
            child: Text(
              userName,
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          Text(user?.email ?? ""),

          const SizedBox(height: 30),

          // ✅ SETTINGS
          Expanded(
            child: ListView(
              children: [

                ListTile(
                  leading: const Icon(Icons.receipt),
                  title: const Text("Order History"),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.orders),
                ),

                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text("Wishlist"),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.favorites),
                ),

                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text("Shipping Address"),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.address),
                ),

                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text("Payment Methods"),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.payment),
                ),

                // ✅ DARK MODE TOGGLE
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {

                    return SwitchListTile(
                      title: const Text("Dark Mode"),
                      value: themeProvider.isDark,
                      onChanged: (_) => themeProvider.toggleTheme(),
                    );
                  },
                ),

                // ✅ LANGUAGE (BASIC)
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text("Language"),
                  subtitle: const Text("English"),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Language settings coming soon")),
                    );
                  },
                ),

                // ✅ LOGOUT
                ListTile(
                  leading:
                      const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {

                    await FirebaseAuth.instance.signOut();

                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.login, (r) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}