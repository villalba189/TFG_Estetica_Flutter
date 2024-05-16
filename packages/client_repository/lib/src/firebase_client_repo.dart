import 'dart:io';

import 'package:client_repository/client_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseClientRepo extends ClientRepo {
  final clientsCollection = FirebaseFirestore.instance.collection('clients');
  final ref = FirebaseStorage.instance.ref();

  @override
  Future<List<ClientModel>> getClients() async {
    try {
      return await clientsCollection
          .orderBy('name', descending: false)
          .get()
          .then((value) => value.docs
              .map((doc) =>
                  ClientModel.fromEntity(ClientEntity.fromMap(doc.data())))
              .toList());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ClientModel> getClientbyId(String id) async {
    try {
      return await clientsCollection.doc(id).get().then((value) =>
          ClientModel.fromEntity(ClientEntity.fromMap(value.data()!)));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addClient(ClientModel client) async {
    try {
      return await clientsCollection
          .doc(client.clientId)
          .set(client.toEntity().toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteClient(String id) async {
    try {
      return await clientsCollection.doc(id).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateClient(ClientModel client) async {
    try {
      return await clientsCollection
          .doc(client.clientId)
          .update(client.toEntity().toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> addImagenStorage(
      String id, String name, String imagePath) async {
    try {
      final file = File(imagePath);

      final ref = this.ref.child('clients').child(name).child(id);
      var task = await ref.putFile(file);
      final url = await task.ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteImagenStorage(ClientModel client) async {
    try {
      final ref =
          this.ref.child('clients').child(client.name!).child(client.clientId!);
      await ref.delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}
