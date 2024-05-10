class BrandEntity {
  final String id;
  final String name;

  BrandEntity({
    required this.id,
    required this.name,
  });
  Map<String, dynamic> toMap() {
    return {
      'barandId': id,
      'name': name,
    };
  }

  factory BrandEntity.fromMap(Map<String, dynamic> map) {
    return BrandEntity(
      id: map['brandId'],
      name: map['name'],
    );
  }
}
