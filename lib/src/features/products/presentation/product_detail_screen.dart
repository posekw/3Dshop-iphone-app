import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../cart/provider/cart_provider.dart';
import '../../cart/presentation/cart_screen.dart';
import '../domain/product.dart';
class ProductDetailTheme {
  static const Color primary = Color(0xFF7311D4);
  static const Color backgroundLight = Color(0xFFF7F6F8);
  static const Color backgroundDark = Color(0xFF191022); // Specific dark bg
  static const Color brandYellow = Color(0xFFFFD700);
  static const Color brandPink = Color(0xFFFF00FF);
}

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  // Variation State
  String? selectedColor;
  String? selectedMaterial;
  
  // Mock Variations for demo (Real app would query API for product attributes)
  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  final List<String> materials = ['PLA', 'PETG', 'ABS'];
  final List<String> colors = ['Black', 'White', 'Rainbow'];

  String selectedSize = 'M';

  @override
  Widget build(BuildContext context) {
    // Using Plus Jakarta Sans for this screen as requested in HTML
    final detailTextTheme = GoogleFonts.plusJakartaSansTextTheme(Theme.of(context).textTheme);
    final product = widget.product;

    return Scaffold(
      backgroundColor: ProductDetailTheme.backgroundDark,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120), // Space for fixed bottom bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Header
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(48), // 3rem approx
                            bottomRight: Radius.circular(48),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(product.images.isNotEmpty ? product.images.first : ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Carousel dots (mock)
                      Positioned(
                        bottom: 24,
                        left: 0, right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDot(true),
                            _buildDot(false),
                            _buildDot(false),
                            _buildDot(false),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Product Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: detailTextTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              Icon(Icons.star, color: ProductDetailTheme.brandYellow, size: 20),
                              const SizedBox(width: 4),
                              Text('4.8', style: TextStyle(color: ProductDetailTheme.brandYellow, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Price
                      Text('\$${product.price}',
                          style: detailTextTheme.headlineSmall?.copyWith(
                              color: ProductDetailTheme.brandYellow, fontWeight: FontWeight.bold)),

                      const SizedBox(height: 32),

                      // Size Selector (Variable Product Support - Example 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SELECT SIZE',
                              style: TextStyle(
                                  color: Colors.grey[300], fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1)),
                          Text('Size Guide',
                              style: TextStyle(
                                  color: ProductDetailTheme.primary, fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: sizes.map((s) => Row(children: [_buildSizeBtn(s), const SizedBox(width: 16)])).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Material Selector (3D Print Specific)
                      if (product.hasVariations) ...[
                         Text('MATERIAL',
                              style: TextStyle(
                                  color: Colors.grey[300], fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1)),
                         const SizedBox(height: 12),
                         Wrap( // Use Wrap for dynamic chips
                           spacing: 12,
                           children: materials.map((m) => ChoiceChip(
                             label: Text(m),
                             selected: selectedMaterial == m,
                             onSelected: (val) => setState(() => selectedMaterial = val ? m : null),
                             selectedColor: ProductDetailTheme.primary,
                             backgroundColor: Colors.transparent,
                             labelStyle: TextStyle(color: selectedMaterial == m ? Colors.white : Colors.grey),
                             shape: StadiumBorder(side: BorderSide(color: Colors.grey[700]!)),
                           )).toList(),
                         ),
                      ],

                      const SizedBox(height: 32),

                      // Description
                      Text('DESCRIPTION',
                          style: TextStyle(
                              color: Colors.grey[300], fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1)),
                      const SizedBox(height: 12),
                      Text(
                        'Experience the perfect blend of street style and comfort. This ${product.name} is crafted with precision. Breathable, durable, and designed for the modern creator.',
                        style: detailTextTheme.bodyMedium?.copyWith(
                          color: Colors.grey[400],
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),
                      
                      // Accordions
                      _buildAccordion('Composition & Care'),
                      _buildAccordion('Shipping & Returns'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top Buttons (Absolute Position)
          Positioned(
            top: 50, // Safe Area approx
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleBtn(Icons.arrow_back, onTap: () => Navigator.pop(context)),
                _buildCircleBtn(Icons.favorite),
              ],
            ),
          ),

          // Bottom Bar (Fixed)
          Positioned(
            bottom: 0,
            left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              decoration: const BoxDecoration(
                color: ProductDetailTheme.backgroundDark,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent, // Fade in effect from HTML not perfectly replicable with simple container, but solid bg works
                    ProductDetailTheme.backgroundDark
                  ],
                  stops: [0.0, 0.1]
                )
              ),
              child: Row(
                children: [
                  // Quantity
                  Container(
                    height: 56,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[800]!.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey[700]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                           icon: const Icon(Icons.remove, size: 18), 
                           color: Colors.white70,
                           onPressed: () => setState(() { if(quantity > 1) quantity--; })),
                        Text('$quantity', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        IconButton(
                           icon: const Icon(Icons.add, size: 18),
                           color: Colors.white70,
                           onPressed: () => setState(() { quantity++; })),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Add to Cart
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          onPressed: () {
                             // Logic to add to cart
                             ref.read(cartProvider.notifier).addToCart(
                               widget.product, 
                               quantity, 
                               selectedSize, 
                               selectedMaterial
                             );
                             
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 backgroundColor: ProductDetailTheme.primary,
                                 content: Text('Added ${widget.product.name} to Cart'),
                                 action: SnackBarAction(label: 'VIEW CART', textColor: Colors.white, onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                                 }),
                               )
                             );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ProductDetailTheme.primary,
                             fixedSize: const Size.fromHeight(56),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                             shadowColor: ProductDetailTheme.primary.withOpacity(0.4),
                             elevation: 8,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 20),
                              SizedBox(width: 8),
                              Text('Add to Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8, height: 8,
      decoration: BoxDecoration(
        color: active ? Colors.black : Colors.black26,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildSizeBtn(String size) {
    final isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () => setState(() => selectedSize = size),
      child: Container(
        width: 56, height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? ProductDetailTheme.primary : Colors.transparent,
          border: isSelected ? null : Border.all(color: Colors.grey[700]!),
          boxShadow: isSelected 
             ? [BoxShadow(color: ProductDetailTheme.primary.withOpacity(0.4), blurRadius: 15)] 
             : null,
        ),
        child: Text(size, 
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400], 
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500
          )),
      ),
    );
  }

  Widget _buildAccordion(String title) {
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[800]!))),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.expand_more, color: Colors.grey),
        onTap: () {}, // Expansion logic can be added later
      ),
    );
  }
}
