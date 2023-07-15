// ignore_for_file: empty_catches, avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

//METODO PARA LLAMAR LAS TRES COLECIONES
class FirestoreService {
  FirebaseFirestore db = FirebaseFirestore.instance;

//ESTE PAQUETE ES PARA SUBIR IMAGENES
  final FirebaseStorage storage = FirebaseStorage.instance;


//LLAMAR A LOS PRODUCTOS EN GENERAL NEGOCIOS/CATEGORIAS/PRODUCTOS
  Future<List<DocumentSnapshot>> getProductosViewTotal() async {
    final QuerySnapshot negocioSnapshot =
        await FirebaseFirestore.instance.collection('Negocios').get();

    final List<Future<QuerySnapshot>> categoriasFutures =
        negocioSnapshot.docs.map((negocioDoc) {
      return negocioDoc.reference.collection('Categorias').get();
    }).toList();

    final List<QuerySnapshot> categoriasSnapshots =
        await Future.wait(categoriasFutures);

    final List<Future<QuerySnapshot>> productosFutures =
        categoriasSnapshots.expand((categoriaSnapshot) {
      return categoriaSnapshot.docs.map((categoriaDoc) {
        return categoriaDoc.reference
            .collection('Productos')
            .orderBy('fecha', descending: true)
            .get();
      });
    }).toList();

    final List<QuerySnapshot> productosSnapshots =
        await Future.wait(productosFutures);

    final List<DocumentSnapshot> documentos =
        productosSnapshots.expand((productosSnapshot) {
      return productosSnapshot.docs;
    }).toList();

    return documentos;
  }

}
