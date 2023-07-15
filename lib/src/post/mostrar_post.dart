// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, avoid_print, use_build_context_synchronously, non_constant_identifier_names
import 'package:delivery_master2/src/models/product_medicine_models.dart';

import 'package:delivery_master2/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MostrarPost extends StatefulWidget {
  final ProductMedicine productMedicine;
  const MostrarPost({
    Key? key,
    required this.productMedicine,
  }) : super(key: key);

  @override
  _MostrarPostState createState() => _MostrarPostState();
}

class _MostrarPostState extends State<MostrarPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueAcents,
        title: Text(widget.productMedicine.nameNegocio),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            _InfoCard(
              widget: widget,
              text: "Nombre del producto:  ",
              text2: widget.productMedicine.nameProduct,
            ),
            const SizedBox(height: 20),
            _InfoCard(
              widget: widget,
              text: "Nombre del negocio:  ",
              text2: widget.productMedicine.nameNegocio,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String text;
  final String text2;
  const _InfoCard({
    required this.widget,
    required this.text,
    required this.text2,
  });

  final MostrarPost widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "MonB",
              color: AppColors.oscureColorb,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10),
          Text(
            text2,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "MonB",
              color: AppColors.oscureColor,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
