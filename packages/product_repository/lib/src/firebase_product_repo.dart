import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_repository/src/models/product.dart';
import 'package:product_repository/src/product_repo.dart';

import 'entities/entities.dart';

class FirebaseProductRepo implements ProductRepo {
  final productsCollection = FirebaseFirestore.instance.collection('products');

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      return await productsCollection.get().then((value) => value.docs
          .map((doc) =>
              ProductModel.fromEntity(ProductEntity.fromMap(doc.data())))
          .toList());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ProductModel> getProductbyId(String productId) async {
    try {
      return await productsCollection.doc(productId).get().then((value) =>
          ProductModel.fromEntity(ProductEntity.fromMap(value.data()!)));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    try {
      return await productsCollection
          .doc(product.productId)
          .set(product.toEntity().toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      return await productsCollection.doc(productId).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      return await productsCollection
          .doc(product.productId)
          .update(product.toEntity().toMap());
    } catch (e) {
      throw Exception(e);
    }
  }
}
