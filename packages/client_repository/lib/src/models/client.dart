import '../entities/entities.dart';

class ClientModel {
  final String? clientId;
  final String? name;
  final String? surname;
  final String? email;
  final String? phone;
  int? discount;
  final String? image;

  ClientModel({
    this.clientId,
    this.name,
    this.surname,
    this.email,
    this.phone,
    this.discount,
    this.image,
  });
  ClientEntity toEntity() {
    return ClientEntity(
      clientId: clientId,
      name: name,
      surname: surname,
      email: email,
      phone: phone,
      discount: discount,
      image: image,
    );
  }

  static ClientModel fromEntity(ClientEntity entity) {
    return ClientModel(
      clientId: entity.clientId,
      name: entity.name,
      surname: entity.surname,
      email: entity.email,
      phone: entity.phone,
      discount: entity.discount,
      image: entity.image,
    );
  }
}
