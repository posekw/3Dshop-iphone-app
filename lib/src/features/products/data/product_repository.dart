import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/api_service.dart';
import '../domain/product.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProductRepository(apiService);
});

class ProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  Future<List<Product>> getProducts({int page = 1, int perPage = 10}) async {
    // Check if keys are placeholders, if so, return Mock Data
    // For now, always return mock data to unblock development
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
    return _mockProducts;
  }
  
  // Mock Data matching the user's domain (3D Printing)
  final List<Product> _mockProducts = [
    Product(
      id: 1,
      name: 'Urban Geometric Tee',
      price: '35.00',
      images: ['https://lh3.googleusercontent.com/aida-public/AB6AXuBh1nQiiSqZ2Y0zLJ9lEH9mpoz7o7oNccyFaKToM_u_mPzGN-euXu3xA3xWqU9iXwcYEKSfJP6_LxL9nbToEdEEhKEL9vIP6qS7uy2Pp_FiNlVuwQM0cw1hs8-N0qSUbWIhhH2gxGqeuVgrN_-c3Nfqku6l3o2c7lSEU_1SyaE8Xaqgamp9FogPXkbMroJ1yToL1jFC5UEXOcTOHxI3cKOo9pYuUfFOdYw0idTZnhDpEWfcLsQpOSF9LOJKNpC1El2qQIx0YYcN3hOo'],
      hasVariations: true,
    ),
    Product(
      id: 2,
      name: 'Low Poly Planter',
      price: '18.50',
      images: ['https://lh3.googleusercontent.com/aida-public/AB6AXuD8Qe_XF7PUCEJKiM4raNBqcQxkrLHpTNPUDfVPj3OzQi2o9crbK62A9TGnU8Cvt4jvV-Fi6c69KlhzMieatKMwQdqA1zWlTFpgcKKaMzG7veQG7QtO7o6WMMfBAhncAwYRMFhIUGaSeEewPcececNpXJ_QE5eLWvEQI7byx0bBdBklWfKqjK82SKqRUwNK_p_10tDiT1dLNgw-qlt9c-FNu79EQLxr1hQ9-nbk89RdJo9POEoTgbPEljH4s8tCRV7YH-uM0NDY2yQj'],
      hasVariations: true, // Material: PLA, PETG
    ),
    Product(
      id: 3,
      name: 'Articulated Dragon',
      price: '45.00',
      images: ['https://lh3.googleusercontent.com/aida-public/AB6AXuAh-Q0LoGH9Qsq5wF0jXdqNtjO0P91wC3qAlMDEGsr4ROjqEjpnaNKGUZTK7NJQn6mtSQfabq4nIpaDg9KDydxklud1_JkUqKmKPH5Cexz5SrQKgLL8tFXNDA9S0bI-gxURhk-QtquSXx8tnAgYmnuj1-ob570zR15a7zJ7Rnc8viUg3OV9qDQipgiRcKX5xbRZCiJVR40L5gy800Ztz9_bf0XLmuJY6PkcG5e4Q0xQKVI7ClQkU3QujF_CR8dJN1MEBWdzVT_-DumL'],
      hasVariations: true, // Color: Rainbow, Gold
    ),
    Product(
      id: 4,
      name: 'Geometric Vase (Vase Mode)',
      price: '22.00',
      images: ['https://lh3.googleusercontent.com/aida-public/AB6AXuCRS9gt-7FzIMWIZ5AV-ev-y9jCGsWVy8OvoX8SBf0nlxAafuhmq9m5KqkYM2IT3S4dQbrAm-l6A94kEVQvDDmNAZarQncNHdoMsQVia-063lOUE11JJmGvdaGdzbjHl6YUZoh1_P4dQ955yOHftFSHjKDH-GJc-HKRzaf6B_xroiji9F7_65Z2LrYy65qsVsxj2msJh9IbjWZj3DHME4LiInzp0wsT0P1TvVFywNjW923rkTsYh1zIGIuYSon3X3jp7FPbWEXXKe3R'],
      hasVariations: false,
    ),
  ];
}
