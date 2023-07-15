import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_master2/src/models/product_medicine_models.dart';
import 'package:delivery_master2/src/post/mostrar_post.dart';
import 'package:delivery_master2/src/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostProductosCard extends StatelessWidget {
  const PostProductosCard({
    Key? key,
    required this.documents,
    this.formattedDate,
    required this.productMedicine,
    this.scrollDirection,
    this.width,
  }) : super(key: key);

  final List<DocumentSnapshot<Object?>> documents;
  final String? formattedDate;
  final List<ProductMedicine> productMedicine;
  final Axis? scrollDirection;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection!,
      physics: const BouncingScrollPhysics(),
      itemCount: documents.length,
      itemBuilder: (BuildContext context, int index) {
        final formatedData =
            DateFormat('dd/MM/yyyy').format(documents[index]["fecha"].toDate());
        return InkWell(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              height: 350,
              width: width,
              child: Stack(
                children: [
                  Card(
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 3, color: AppColors.text),
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => const SizedBox(
                            height: 400,
                            width: 400,
                          ),
                          imageUrl: documents[index]["imagenUrl"],
                          fit: BoxFit.cover,
                          height: 400,
                          width: 400,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 7,
                    left: 7,
                    child: Container(
                      width: 160,
                      decoration: const BoxDecoration(
                          color: AppColors.colorAcento,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(19),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(15))),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              documents[index]["nameProduct"],
                              maxLines: 1,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: "MonB",
                                  fontSize: 16,
                                  color: AppColors.oscureColorb),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: AppColors.colorAcento,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              topRight: Radius.circular(18))),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          formatedData,
                          style: const TextStyle(
                              fontFamily: "MonB",
                              fontSize: 14,
                              color: AppColors.oscureColorb),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MostrarPost(
                  productMedicine: productMedicine[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
