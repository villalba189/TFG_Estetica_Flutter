import 'package:brand_repository/src/entities/brand_entity.dart';

class BrandModel {
  final String id;
  final String name;
  BrandModel({
    required this.id,
    required this.name,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'],
      name: json['name'],
    );
  }

  BrandEntity toEntity() {
    return BrandEntity(
      id: id,
      name: name,
    );
  }

  static BrandModel fromEntity(BrandEntity entity) {
    return BrandModel(
      id: entity.id,
      name: entity.name,
    );
  }
}
