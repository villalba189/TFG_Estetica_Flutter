import 'package:cloud_firestore/cloud_firestore.dart';

import '../brand_repository.dart';

class FirebaseBrandRepo implements BrandRepo {
  final brandsCollection = FirebaseFirestore.instance.collection('brands');

  @override
  Future<void> addNewBrand(BrandModel brand) async {
    try {
      return await brandsCollection.doc(brand.id).set(brand.toEntity().toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteBrand(BrandModel brand) async {
    try {
      return await brandsCollection.doc(brand.id).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<BrandModel>> getBrands() async {
    try {
      return await brandsCollection.get().then((value) => value.docs
          .map((doc) => BrandModel.fromEntity(BrandEntity.fromMap(doc.data())))
          .toList());
    } catch (e) {
      throw Exception(e);
    }
  }
}
