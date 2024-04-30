import 'package:product_repository/src/entities/entities.dart';

class ProductModel {
  final String? productId;
  final String? name;
  final String? description;
  final String? price;
  final String? brand;
  final String? image;

  ProductModel({
    this.productId,
    this.name,
    this.description,
    this.price,
    this.brand,
    this.image,
  });
  ProductEntity toEntity() {
    return ProductEntity(
      productId: productId,
      name: name,
      description: description,
      price: price,
      brand: brand,
      image: image,
    );
  }

  static ProductModel fromEntity(ProductEntity entity) {
    return ProductModel(
      productId: entity.productId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      brand: entity.brand,
      image: entity.image,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $productId, name: $name, description: $description, price: $price, brand: $brand, image: $image)';
  }
}
