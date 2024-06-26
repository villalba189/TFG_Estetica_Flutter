import 'package:client_repository/client_repository.dart';
import 'package:product_repository/product_repository.dart';
import 'package:service_repository/service_repository.dart';

class TicketEntity {
  final String id;
  final ClientEntity client;
  final DateTime date;
  String total;
  String totalDes;
  final List<LineaTicket> lineas;

  TicketEntity({
    required this.id,
    required this.client,
    required this.date,
    required this.total,
    required this.totalDes,
    required this.lineas,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client': client.toMap(),
      'date': date,
      'total': total,
      'totalDes': totalDes,
      'lineas': lineas.map((e) => e.toMap()).toList(),
    };
  }

  factory TicketEntity.fromMap(Map<String, dynamic> map) {
    return TicketEntity(
      id: map['id'],
      client: ClientEntity.fromMap(map['client']),
      date: map['date'],
      total: map['total'],
      totalDes: map['totalDes'],
      lineas: List<LineaTicket>.from(
          map['lineas']?.map((x) => LineaTicket.fromMap(x))),
    );
  }
}

class LineaTicket {
  final String id;
  final ProductEntity? product;
  final ServiceEntity? service;
  double subtotal;
  int quantity;

  LineaTicket({
    required this.id,
    this.product,
    this.service,
    required this.subtotal,
    required this.quantity,
  });
  Map<String, dynamic> toMap() {
    return {
      'lineaId': id,
      'product': product?.toMap(),
      'service': service?.toMap(),
      'subtotal': subtotal,
      'quantity': quantity,
    };
  }

  factory LineaTicket.fromMap(Map<String, dynamic> map) {
    return LineaTicket(
      id: map['id'],
      product: ProductEntity.fromMap(map['product']),
      service: ServiceEntity.fromMap(map['service']),
      subtotal: (map['subtotal'] as num).toDouble(),
      quantity: map['quantity'],
    );
  }
}
