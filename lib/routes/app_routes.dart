import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/main_navigation.dart';
import '../screens/home_screen.dart';
import '../screens/category_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/address_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/search_screen.dart';

// ✅ NEW FILTER SCREEN
import '../screens/filtered_products_screen.dart';

class AppRoutes {

  // ✅ Route names
  static const welcome = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const category = '/category';
  static const product = '/product';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const profile = '/profile';
  static const favorites = '/favorites';
  static const orders = '/orders';
  static const address = '/address';
  static const payment = '/payment';
  static const search = '/search';

  // ✅ NEW FILTER ROUTE
  static const filtered = '/filtered';

  // ✅ Route map
  static final Map<String, WidgetBuilder> routes = {

    // AUTH
    welcome: (context) => const WelcomeScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),

    // ✅ MAIN NAVIGATION
    home: (context) => const MainNavigation(),

    // ✅ MAIN SCREENS
    category: (context) => const CategoryScreen(),
    product: (context) => const ProductDetailScreen(),
    cart: (context) => const CartScreen(),
    checkout: (context) => const CheckoutScreen(),
    profile: (context) => const ProfileScreen(),
    favorites: (context) => const FavoriteScreen(),

    // ✅ EXTRA FEATURES
    orders: (context) => const OrderHistoryScreen(),
    address: (context) => const AddressScreen(),
    payment: (context) => const PaymentScreen(),

    // ✅ SEARCH
    search: (context) => const SearchScreen(),

    // ✅ ✅ NEW FILTERED PRODUCT SCREEN
    filtered: (context) => const FilteredProductsScreen(),
  };
}

// ✅ Screens
