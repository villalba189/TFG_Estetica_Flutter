import 'models/models.dart';

abstract class ServiceRepo {
  Future<ServiceModel> getServicebyId(String id);
  Future<List<ServiceModel>> getServices();
  Future<void> addService(ServiceModel service);
  Future<void> updateService(ServiceModel service);
  Future<void> deleteService(String id);
  Future<String> addImagenStorage(String id, String name, String imagePath);
}
