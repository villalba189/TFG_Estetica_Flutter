class ProductEntity {
  final String? productId;
  final String? name;
  final String? description;
  final String? price;
  final String? brand;
  final String? image;

  ProductEntity({
    this.productId,
    this.name,
    this.description,
    this.price,
    this.brand,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'brand': brand,
      'image': image,
    };
  }

  factory ProductEntity.fromMap(Map<String, dynamic> map) {
    return ProductEntity(
      productId: map['productId'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      brand: map['brand'],
      image: map['image'],
    );
  }
}
