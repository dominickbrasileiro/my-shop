class PartialProduct {
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  PartialProduct({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
