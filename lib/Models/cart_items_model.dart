class CartItemModel {
  final String productId;
  final String name;
  final String image;
  final double price;
  int quantity;
  final String? size;
  final String? color;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
    this.size,
    this.color,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'],
      name: map['name'],
      image: map['imageUrl'],
      price: map['price'].toDouble(),
      quantity: map['quantity'],
      size: map['size'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': image,
      'price': price,
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }

  double get totalPrice => price * quantity;
}