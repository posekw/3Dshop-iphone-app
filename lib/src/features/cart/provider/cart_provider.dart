import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/domain/product.dart';

// Simple Cart Item model
class CartItem {
  final Product product;
  final int quantity;
  final String? selectedSize;
  final String? selectedMaterial;

  CartItem({
    required this.product, 
    required this.quantity,
    this.selectedSize,
    this.selectedMaterial,
  });

  double get totalPrice => double.parse(product.price) * quantity;
}

// Cart Notifier
class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addToCart(Product product, int quantity, String? size, String? material) {
    state = [
      ...state,
      CartItem(
        product: product, 
        quantity: quantity,
        selectedSize: size,
        selectedMaterial: material,
      )
    ];
  }

  void removeFromCart(int index) {
     final newState = [...state];
     newState.removeAt(index);
     state = newState;
  }
  
  void clearCart() {
    state = [];
  }

  double get grandTotal => state.fold(0, (sum, item) => sum + item.totalPrice);
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);
