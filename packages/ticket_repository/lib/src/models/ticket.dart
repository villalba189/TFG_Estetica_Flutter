import 'package:client_repository/client_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_repository/product_repository.dart';
import 'package:service_repository/service_repository.dart';
import 'package:ticket_repository/src/entities/entities.dart';

class TicketModel {
  final String id;
  final ClientModel client;
  final Timestamp date;
  final String total;
  final String totalDes;
  final List<LineaTicketModel> lineas;

  TicketModel({
    required this.id,
    required this.client,
    required this.date,
    required this.total,
    required this.totalDes,
    required this.lineas,
  });
  TicketEntity toEntity() {
    return TicketEntity(
      id: id,
      client: client.toEntity(),
      date: date,
      total: total,
      totalDes: totalDes,
      lineas: lineas.map((e) => e.toEntity()).toList(),
    );
  }

  static TicketModel fromEntity(TicketEntity entity) {
    return TicketModel(
      id: entity.id,
      client: ClientModel.fromEntity(entity.client),
      date: entity.date,
      total: entity.total,
      totalDes: entity.totalDes,
      lineas: entity.lineas.map((e) => LineaTicketModel.fromEntity(e)).toList(),
    );
  }
}

class LineaTicketModel {
  final String id;
  final ProductModel? product;
  final ServiceModel? service;
  final String subtotal;
  final String quantity;

  LineaTicketModel({
    required this.id,
    this.product,
    this.service,
    required this.subtotal,
    required this.quantity,
  });
  LineaTicket toEntity() {
    return LineaTicket(
      id: id,
      product: product?.toEntity(),
      service: service?.toEntity(),
      subtotal: subtotal,
      quantity: quantity,
    );
  }

  static LineaTicketModel fromEntity(LineaTicket entity) {
    return LineaTicketModel(
      id: entity.id,
      product: entity.product != null
          ? ProductModel.fromEntity(entity.product!)
          : null,
      service: entity.service != null
          ? ServiceModel.fromEntity(entity.service!)
          : null,
      subtotal: entity.subtotal,
      quantity: entity.quantity,
    );
  }
}
