import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_master2/src/models/product_medicine_models.dart';
import 'package:delivery_master2/src/post/post_mascotacard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/app_colors.dart';

class ContenidoNegocios extends StatefulWidget {
  final String? nameNegocio;
  final bool filtrarAprobado;
  final double width;
  final Axis scrollDirection;
  final Widget loadingWidget;
  //final double? height;
  final Future<List<DocumentSnapshot>> futureProductos;
  const ContenidoNegocios({
    super.key,
    this.nameNegocio,
    required this.futureProductos,
    required this.filtrarAprobado,
    required this.width,
    required this.scrollDirection,
    required this.loadingWidget,
    //this.height
  });

  @override
  State<ContenidoNegocios> createState() => _ContenidoNegociosState();
}

class _ContenidoNegociosState extends State<ContenidoNegocios> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Configurar el temporizador para refrescar cada segundo
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    // Cancelar el temporizador al salir de la página
    _stopTimer();
  }

  void _startTimer() {
    // Iniciar el timer para refrescar cada segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      // Lógica de actualización aquí
      setState(() {});
    });
  }

  void _stopTimer() {
    // Detener el timer
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: widget.futureProductos,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Obtener los datos de Firestore y crear una lista de instancias de Mascota
          List<ProductMedicine> productMedicine = snapshot.data!.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return ProductMedicine(
              uid: doc.id,
              nameProduct: data.containsKey("nameProduct")
                  ? data["nameProduct"].toString()
                  : "",
              nameNegocio: data.containsKey("nameNegocio")
                  ? data["nameNegocio"].toString()
                  : "",
              nameTipoCategory: data.containsKey("nameTipoCategory")
                  ? data["nameTipoCategory"].toString()
                  : "",
              nameColectionFinal: data.containsKey("nameColectionFinal")
                  ? data["nameColectionFinal"].toString()
                  : "",
              precio: data.containsKey("precio") ? data["precio"] : "",
             
              nameCategory: data.containsKey("nameCategory")
                  ? data["nameCategory"].toString()
                  : "",
              categoria: data.containsKey("categoria")
                  ? data["categoria"].toString()
                  : "",
           
             
              cantidad: data.containsKey("cantidad")
                  ? data["cantidad"].toString()
                  : "",
              descripcion: data.containsKey("descripcion")
                  ? data["descripcion"].toString()
                  : "",
              recomendaciones: data.containsKey("recomendaciones")
                  ? data["recomendaciones"].toString()
                  : "",
              imagenUrl: data.containsKey("imagenUrl")
                  ? data["imagenUrl"].toString()
                  : "",
         
              fecha: DateTime.now(),
        
            );
          }).toList();

          //PARA LLAMAR A LA FECHA
          final fecha = snapshot.hasData && snapshot.data!.isNotEmpty
              ? snapshot.data![0]['fecha'] as Timestamp
              : null;
          if (fecha == null) {
            return const Text(
              'No hay publicaciones disponibles',
              style: TextStyle(fontFamily: "MonB", color: AppColors.text),
            );
          }
          final formattedDate = DateFormat('dd/MM/yyyy').format(fecha.toDate());
          final List<DocumentSnapshot> documents = snapshot.data!;
          //final List<DocumentSnapshot> documents = snapshot.data!.docs.toList();
          return SizedBox(
            height: 250,
            child: PostProductosCard(
              width: widget.width,
              scrollDirection: widget.scrollDirection,
              documents: documents,
              formattedDate: formattedDate,
              productMedicine: productMedicine,
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error al obtener datos'),
          );
        } else {
          return widget.loadingWidget;
        }
      },
    );
  }
}
