import 'models/models.dart';

abstract class ProductRepo {
  Future<ProductModel> getProductbyId(String id);
  Future<List<ProductModel>> getProducts();
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}
