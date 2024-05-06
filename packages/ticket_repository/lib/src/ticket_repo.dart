import 'models/models.dart';

abstract class TicketRepo {
  Future<List<TicketModel>> getTicketsbyClientId(String id);
  Future<List<TicketModel>> getTickets();
  Future<void> addTicket(TicketModel ticket);
  Future<void> deleteLinea(LineaTicketModel linea);
}
