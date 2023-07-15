import 'package:delivery_master2/src/post/add_post_product.dart';
import 'package:delivery_master2/src/post/contenido_negocios.dart';
import 'package:delivery_master2/src/services/firebase_services.dart';
import 'package:delivery_master2/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.oscureColor,
        title: const Text("Bienvenido"),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.add_shopping_cart, size: 40),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ContenidoNegocios(
              futureProductos: _firestoreService.getProductosViewTotal(),
              filtrarAprobado: true,
              width: 200,
              scrollDirection: Axis.horizontal,
              loadingWidget: const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddPostProductos()));
        },
      ),
    );
  }
}
