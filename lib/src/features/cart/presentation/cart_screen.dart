import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../provider/cart_provider.dart';
import '../../checkout/presentation/checkout_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.read(cartProvider.notifier).grandTotal;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        title: const Text('My Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
                   const SizedBox(height: 16),
                   Text('Your Cart is Empty', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Dismissible(
                        key: ValueKey('${item.product.id}_$index'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          ref.read(cartProvider.notifier).removeFromCart(index);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[900]!),
                          ),
                          child: Row(
                            children: [
                              // Thumb
                              Container(
                                width: 80, height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[800],
                                  image: DecorationImage(
                                    image: NetworkImage(item.product.images.first),
                                    fit: BoxFit.cover,
                                  )
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name, 
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text('${item.selectedSize ?? ''} ${item.selectedMaterial != null ? ' | ${item.selectedMaterial}' : ''}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('\$${item.totalPrice.toStringAsFixed(2)}', 
                                          style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold)),
                                        Text('x${item.quantity}', style: const TextStyle(color: Colors.white)),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.accent, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
