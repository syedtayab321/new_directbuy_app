import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../views/dashboard/cart/cart_screen.dart';
import '../../views/dashboard/home/home_screen.dart';
import '../../views/dashboard/order/order_screen.dart';
import '../../views/dashboard/profile/profile_screen.dart';


class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;
  final List<Widget> pages = [
          HomeScreen(),
          CartScreen(),
          OrdersScreen(),
          ProfileScreen(),
  ];

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}