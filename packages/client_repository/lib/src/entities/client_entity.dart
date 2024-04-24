class ClientEntity {
  final String clientId;
  final String name;
  final String? surname;
  final String? email;
  final String? phone;
  final String? discount;
  final String? image;

  ClientEntity({
    required this.clientId,
    required this.name,
    this.surname,
    this.email,
    this.phone,
    this.discount,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'name': name,
      'surname': surname,
      'email': email,
      'phone': phone,
      'discount': discount,
      'image': image,
    };
  }

  factory ClientEntity.fromMap(Map<String, dynamic> map) {
    return ClientEntity(
      clientId: map['clientId'],
      name: map['name'],
      surname: map['surname'],
      email: map['email'],
      phone: map['phone'],
      discount: map['discount'],
      image: map['image'],
    );
  }
}
