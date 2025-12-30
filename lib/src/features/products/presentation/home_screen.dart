import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../data/product_repository.dart';
import '../domain/product.dart';

import '../../cart/presentation/cart_screen.dart';
import 'product_detail_screen.dart';

// Temporary provider for UI
final productsFutureProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).getProducts();
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsFutureProvider); 

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: CustomScrollView(
        slivers: [
          // Sticky Header
          const SliverAppBar(
            backgroundColor: AppTheme.backgroundDark,
            floating: true,
            pinned: true,
            titleSpacing: 0,
            toolbarHeight: 80,
            title: HomeHeader(),
          ),
          
          // Content
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          
          // Hero Carousel
          SliverToBoxAdapter(
            child: SizedBox(
               height: 400,
               child: HeroCarousel(),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Categories
          SliverToBoxAdapter(
            child: CategoryFilterList(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // "Trending Now" Title
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text('Trending Now', style: Theme.of(context).textTheme.displaySmall),
                   TextButton(
                     onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('See All Clicked'))),
                     child: const Text('See All', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                   ),
                ],
              ),
            ),
          ),

          // Product Grid
          productsAsync.when(
            data: (products) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
               sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                     if (index >= products.length) return const SizedBox();
                     final product = products[index];

                     return GestureDetector(
                       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
                       child: ProductCard(product: product),
                     );
                  },
                  childCount: products.length,
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (err, stack) => SliverToBoxAdapter(child: Text('Error: $err')),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom padding
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo Area
              Row(
                children: [
                   // Custom Logo
                   Image.asset('assets/images/logo.png', width: 40, height: 40),
                   const SizedBox(width: 8),
                   Text('3 SHOP', style: Theme.of(context).textTheme.displaySmall?.copyWith(letterSpacing: 2)),
                ],
              ),
              // Bag Icon
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                child: Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                    ),
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        width: 10, height: 10,
                        decoration: const BoxDecoration(color: AppTheme.secondary, shape: BoxShape.circle),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          // Search Bar would go here if part of the same sticky block, but SliverAppBar title has limited height.
          // Cleaner to make search separate or use bottom property of SliverAppBar.
        ],
      ),
    );
  }
}

class HeroCarousel extends StatelessWidget {
  const HeroCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.85),
      padEnds: false, // Align left like HTML snap-center often implies if not centered
      itemCount: 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 16, left: 24), // Gap
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: NetworkImage(index == 0 
                  ? 'https://lh3.googleusercontent.com/aida-public/AB6AXuAvn2MG0-lC-fSntJtjIUiADexJbisdnaGjyrbPjwftMxu-uBbt50NAwDNkw0k-lX2cTZUGoU_vR-5N2pn6epOM6SlPXNVF70NyZkLLogX-ekGags27BA_MUFfRx7oESGMf_kacNrOmVFbJfWQQY-TVC5-DUCJrqo3GaJqwFQmsq1oHkPtXHYB48xOCaejxzdh_lumEIRQW5eEIE1W-7zyTavnGeFi1ZePPvkLGHBhCxNumFQ4R9g3n8o8rOV8KtOgx5TQRZgA1v7xb'
                  : 'https://lh3.googleusercontent.com/aida-public/AB6AXuBPujrtQT92VJBM24UZBH_Wa0-93-MTzzRwk9tIZS1CLYjo3wlCPGta3U9Sf5zeG6e_NZuha1VDoBPBT0CvOJJy2lg7f9OtILHM99ox4bpSIe3yQaxedwVIcP1F40JC7D94pe7W6ks1-WVnua5LJ9xZ5RqN96a_uQYhpckwY_E1QE22GGAkAzBiVoCEsgA0Td7vBQAJiT3j8FQjc1qoq7IwuSharvjqycvCuVxIMMxu7zLmM7lrYXnr9TXx1pj4g40lf1AS50y5uGR2'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
              ),
            ),
            child: Stack(
              children: [
                // Gradient
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                         AppTheme.backgroundDark.withOpacity(0.9),
                         index == 0 ? AppTheme.primary.withOpacity(0.4) : AppTheme.secondary.withOpacity(0.4),
                         Colors.transparent
                      ],
                    ),
                  ),
                ),
                // Text Content
                Positioned(
                  bottom: 24, left: 24, right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                         decoration: BoxDecoration(
                           color: index == 0 ? AppTheme.accent : AppTheme.primary,
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: Text(index == 0 ? 'NEW DROP' : 'TRENDING', 
                           style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                       ),
                       const SizedBox(height: 8),
                       Text(index == 0 ? 'URBAN\nLEGEND' : 'SUMMER\nVIBES', 
                         style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 32, height: 1.1)),
                       const SizedBox(height: 8),
                       Text(index == 0 ? 'Limited edition graphic hoodies.' : 'Fresh prints for the heat.',
                         style: Theme.of(context).textTheme.bodyMedium),
                       const SizedBox(height: 16),
                       ElevatedButton(
                         onPressed: (){
                           // Navigate to Catalog (placeholder)
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigating to Catalog...')));
                         }, 
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.white, 
                           foregroundColor: index == 0 ? AppTheme.primary : AppTheme.secondary
                         ),
                         child: Text(index == 0 ? 'Shop Now' : 'Explore'),
                       )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class CategoryFilterList extends StatelessWidget {
  const CategoryFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Hoodies', 'T-Shirts', 'Accessories'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_,__) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return GestureDetector(
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected: ${categories[index]}')));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceDarkHighlight,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: isSelected ? AppTheme.primary : Colors.grey[800]!),
              ),
              child: Text(categories[index], 
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[400], 
                  fontWeight: FontWeight.bold
                )),
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[900]!),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(12),
                     image: DecorationImage(
                       image: NetworkImage(product.images.isNotEmpty ? product.images.first : ''),
                       fit: BoxFit.cover
                     )
                  ),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border, size: 16, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(product.name, 
            maxLines: 2, overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${product.price}', style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: BottomNavigationBar(
        backgroundColor: AppTheme.surfaceDark,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Navigating to tab $index...')));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
