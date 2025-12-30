class Product {
  final int id;
  final String name;
  final String price;
  final List<String> images; // URLs
  final bool hasVariations;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.images,
    this.hasVariations = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parsing images from WooCommerce structure
    final imageList = (json['images'] as List?)
        ?.map((img) => (img as Map)['src'] as String)
        .toList() ?? [];

    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as String,
      images: imageList,
      hasVariations: (json['variations'] as List?)?.isNotEmpty ?? false,
    );
  }
}
