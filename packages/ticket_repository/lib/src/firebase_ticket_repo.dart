import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../ticket_repository.dart';

class FirebaseTicketRepo implements TicketRepo {
  final ticketsCollection = FirebaseFirestore.instance.collection('tickets');
  final lineasCollection = FirebaseFirestore.instance.collection('lineas');

  @override
  Future<List<TicketModel>> getTickets() async {
    try {
      return await ticketsCollection.get().then((value) => value.docs
          .map(
              (doc) => TicketModel.fromEntity(TicketEntity.fromMap(doc.data())))
          .toList());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<TicketModel>> getTicketsbyClientId(String id) async {
    try {
      return await ticketsCollection
          .where('client.id', isEqualTo: id)
          .get()
          .then((value) => value.docs
              .map((doc) =>
                  TicketModel.fromEntity(TicketEntity.fromMap(doc.data())))
              .toList());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addTicket(TicketModel ticket) async {
    log('addTicket');
    try {
      return await ticketsCollection
          .doc(ticket.id)
          .set(ticket.toEntity().toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteLinea(LineaTicketModel linea) async {
    try {
      return await lineasCollection.doc(linea.id).delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}
