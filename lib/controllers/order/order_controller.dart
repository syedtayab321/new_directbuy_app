import 'package:get/get.dart';
import '../../Models/order_model.dart';
import '../../repositories/order/order_repository.dart';
import '../../shared/tracking_status.dart';
import '../cart/cart_controller.dart';

class OrderController extends GetxController {
  final OrderRepository repository = OrderRepository();
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<OrderModel?> currentOrder = Rx<OrderModel?>(null);

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading(true);
      errorMessage.value = '';
      await repository.getOrders().first.then((orders) {
        this.orders.assignAll(orders);
      });
    } catch (e) {
      errorMessage.value = 'Failed to load orders: ${e.toString()}';
    } finally {
      isLoading(false);
    }
  }

  Future<OrderModel?> getOrderDetails(String orderId) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      final order = await repository.getOrderById(orderId);
      currentOrder.value = order;
      return order;
    } catch (e) {
      errorMessage.value = 'Failed to load order details: ${e.toString()}';
      return null;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> placeOrder({
    required String shippingAddress,
    required String paymentMethod,
    required List<OrderItem> items,
    required double totalAmount,
  }) async {
    try {
      isLoading(true);
      errorMessage.value = '';

      final order = OrderModel(
        id: '', // Temporary empty ID
        userId: repository.currentUserId,
        orderDate: DateTime.now(),
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        shippingAddress: shippingAddress,
        items: items,
        status: TrackingStatus.placed,
      );

      final orderId = await repository.placeOrder(order);

      if (orderId.isEmpty) {
        throw Exception('Failed to get order ID');
      }

      final confirmedOrder = order.copyWith(id: orderId);
      currentOrder.value = confirmedOrder;

      Get.find<CartController>().clearCart();
      await fetchOrders();

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to place order: ${e.toString()}';
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      final success = await repository.updateOrderStatus(
        orderId: orderId,
        status: TrackingStatus.cancelled,
      );

      if (success) {
        await fetchOrders();
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Failed to cancel order: ${e.toString()}';
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<List<OrderModel>> getOrdersByStatus(TrackingStatus status) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      final filteredOrders = await repository.getOrdersByStatus(status);
      return filteredOrders;
    } catch (e) {
      errorMessage.value = 'Failed to filter orders: ${e.toString()}';
      return [];
    } finally {
      isLoading(false);
    }
  }

  OrderModel? get latestOrder {
    if (orders.isEmpty) return null;
    return orders.reduce((current, next) =>
    current.orderDate.isAfter(next.orderDate) ? current : next
    );
  }
}