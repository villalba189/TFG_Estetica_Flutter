import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_repository/src/models/product.dart';
import 'package:product_repository/src/product_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'entities/entities.dart';

class FirebaseProductRepo implements ProductRepo {
  final productsCollection = FirebaseFirestore.instance.collection('products');
  final ref = FirebaseStorage.instance.ref();

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

  @override
  Future<String> addImagenStorage(
      String productId, String name, String imagePath) async {
    try {
      final file = File(imagePath);
      if (!file.existsSync()) {
        throw FileSystemException("Archivo no encontrado: $imagePath");
      }

      final ref = this.ref.child('products').child(name).child(productId);
      var task = await ref.putFile(file);
      final url = await task.ref.getDownloadURL();
      return url;
    } catch (e) {
      rethrow; // Esto permitirá que se maneje más arriba en la cadena.
    }
  }
}
