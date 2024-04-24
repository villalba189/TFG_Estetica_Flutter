class ServiceEntity {
  ServiceEntity({
    required this.serviceId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  final String serviceId;
  final String name;
  final String description;
  final String price;
  final String image;

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }

  factory ServiceEntity.fromMap(Map<String, dynamic> map) {
    return ServiceEntity(
      serviceId: map['serviceId'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      image: map['image'],
    );
  }
}
