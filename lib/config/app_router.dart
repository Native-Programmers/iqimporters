import 'package:flutter/material.dart';
import 'package:qbazar/models/sub_category_model.dart';
import 'package:qbazar/screens/all_products/all_products.dart';
import 'package:qbazar/screens/auth/forget_password.dart';
import 'package:qbazar/screens/catalog/category_product_screen.dart';
import 'package:qbazar/screens/catalog/subcategory_screen.dart';
import 'package:qbazar/screens/orders/order_history.dart';
import 'package:qbazar/screens/screens.dart';
import 'package:qbazar/models/models.dart';
import 'package:qbazar/wrapper/wrapper.dart';
import 'package:qbazar/extension/string_extension.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    var routingData = settings.name?.getRoutingData;
    // ignore: avoid_print
    print('This is the route name ${settings.name}');
    switch (settings.name) {
      case PhoneAuth.routeName:
        return PhoneAuth.route();
      case ForgetPassword.routeName:
        return ForgetPassword.route();
      case Wrapper.routeName:
        return Wrapper.route();
      case Login.routeName:
        return Login.route();
      case SignUp.routeName:
        return SignUp.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case CartScreen.routeName:
        return CartScreen.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      case WishListScreen.routeName:
        return WishListScreen.route();
      case DetailsScreen.routeName:
        return DetailsScreen.route(product: settings.arguments as Product);
      case BillingScreen.routeName:
        return BillingScreen.route();
      case CheckoutScreen.routeName:
        return CheckoutScreen.route();
      case CatalogScreen.routeName:
        return CatalogScreen.route(category: settings.arguments as Categories);
      case CategoryProductScreen.routeName:
        return CategoryProductScreen.route(
            category: settings.arguments as Categories);
      case SubCategoryScreen.routeName:
        return SubCategoryScreen.route(
            subCategory: settings.arguments as SubCategories);

      case AllProductsScreen.routeName:
        return AllProductsScreen.route();
      case OrderHistory.routeName:
        return OrderHistory.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => const Scaffold(
        body: Error(),
      ),
    );
  }
}
