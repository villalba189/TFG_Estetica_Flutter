import 'package:service_repository/service_repository.dart';

class ServiceModel {
  final String? serviceId;
  final String? name;
  final String? description;
  final double? price;
  final String? image;

  ServiceModel({
    this.serviceId,
    this.name,
    this.description,
    this.price,
    this.image,
  });

  ServiceEntity toEntity() {
    return ServiceEntity(
      serviceId: serviceId,
      name: name,
      description: description,
      price: price,
      image: image,
    );
  }

  static ServiceModel fromEntity(ServiceEntity entity) {
    return ServiceModel(
      serviceId: entity.serviceId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      image: entity.image,
    );
  }
}
