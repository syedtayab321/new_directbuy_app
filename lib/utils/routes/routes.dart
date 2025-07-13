import 'package:get/get.dart';
import '../../views/checkout/checkout_screen.dart';
import '../../views/checkout/order_confirmation_screen.dart';
import '../../views/dashboard/main_dashboard.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/signup_screen.dart';
import '../../views/common/splash_screen.dart';
import '../../views/dashboard/order/order_details_screen.dart';
import '../../views/dashboard/order/order_screen.dart';
import '../../views/products/product_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String products = '/products';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
  static const String orders = '/orders';
  static const String orderDetails = '/order-details';

  // Route list
  static final List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: login,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signup,
      page: () => SignupScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home,
      page: () => BottomBarScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: products,
      page: () => ProductsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: checkout,
      page: () => CheckoutScreen(),
    ),
    GetPage(
      name: orderConfirmation,
      page: () => OrderConfirmationScreen(order: Get.arguments),
    ),
    GetPage(
      name: orders,
      page: () => OrdersScreen(),
    ),
    GetPage(
      name: orderDetails,
      page: () => OrderDetailScreen(orderId: Get.arguments),
    ),
  ];
}