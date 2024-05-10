import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../service_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServiceRepo implements ServiceRepo {
  final servicesCollection = FirebaseFirestore.instance.collection('services');
  final ref = FirebaseStorage.instance.ref();

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      return await servicesCollection.get().then((value) => value.docs
          .map((doc) =>
              ServiceModel.fromEntity(ServiceEntity.fromMap(doc.data())))
          .toList());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ServiceModel> getServicebyId(String serviceId) async {
    try {
      return await servicesCollection.doc(serviceId).get().then((value) =>
          ServiceModel.fromEntity(ServiceEntity.fromMap(value.data()!)));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addService(ServiceModel service) async {
    try {
      return await servicesCollection
          .doc(service.serviceId)
          .set(service.toEntity().toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteService(String serviceId) async {
    try {
      return await servicesCollection.doc(serviceId).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateService(ServiceModel service) async {
    try {
      return await servicesCollection
          .doc(service.serviceId)
          .update(service.toEntity().toMap());
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

      final ref = this.ref.child('services').child(name).child(productId);
      var task = await ref.putFile(file);
      final url = await task.ref.getDownloadURL();
      return url;
    } catch (e) {
      rethrow; // Esto permitirá que se maneje más arriba en la cadena.
    }
  }
}
