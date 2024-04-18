import 'package:client_repository/src/models/client.dart';

abstract class ClientRepo {
  Future<ClientModel> getClientbyId(String id);
  Future<List<ClientModel>> getClients();
  Future<void> addClient(ClientModel client);
  Future<void> updateClient(ClientModel client);
  Future<void> deleteClient(String id);
}
