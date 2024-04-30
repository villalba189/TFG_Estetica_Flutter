import '../service_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServiceRepo implements ServiceRepo {
  final servicesCollection = FirebaseFirestore.instance.collection('services');

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
}
