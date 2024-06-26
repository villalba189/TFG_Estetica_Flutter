class ServiceEntity {
  ServiceEntity({
    this.serviceId,
    this.name,
    this.description,
    this.price,
    this.image,
  });

  final String? serviceId;
  final String? name;
  final String? description;
  final double? price;
  final String? image;

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
      price: (map['price'] as num).toDouble(),
      image: map['image'],
    );
  }
}
