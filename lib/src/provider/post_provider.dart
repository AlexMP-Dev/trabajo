// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_master2/src/services/local_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../services/push_notification_service.dart';
import '../utils/app_colors.dart';

class PostProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _errorMessage;
  String get errorMessage => _errorMessage ?? "";

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  File? _imageUser;
  File? get imageUser => _imageUser;
  set imageUser(File? value) {
    _imageUser = value;
    notifyListeners();
  }

  File? _image;
  dynamic get image => _image;

  Future<void> postMascotas({
    required File? image,
    required String nameProduct,
    required String nameNegocio,
    required String nameCategory,
    required String uid,
    required String username,
    required String precio,
    required String cantidad,
    required String nameTipoCategory,
    required String nameColectionFinal,
    required String descripcion,
    required String recomendaciones,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      // Subir las tres imágenes a Firebase Storage
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String pathPrefix = "Negocios/$nameNegocio";
      String imagePath1 = "$pathPrefix$timestamp-1.png";

      String? imagenUrl;

      if (image != null) {
        final storageRef1 = FirebaseStorage.instance.ref().child(imagePath1);
        final uploadTask1 = storageRef1.putFile(image);
        final snapshot1 = await uploadTask1.whenComplete(() {});

        if (snapshot1.state == TaskState.success) {
          imagenUrl = await snapshot1.ref.getDownloadURL();
        }
      }

      // Guardar la información en Firestore
      await _firestore
          .collection("Negocios")
          .doc(nameNegocio)
          .collection(nameTipoCategory)
          .doc(nameCategory)
          .collection(nameColectionFinal)
          .doc()
          .set({
        "uid": uid,
        "nameProduct": nameProduct,
        "nameNegocio": nameNegocio,
        "nameTipoCategory": nameTipoCategory,
        "nameColectionFinal": nameColectionFinal,
        "nameCategory": nameCategory,
        "username": username,
        "precio": precio,
        "cantidad": cantidad,
        "descripcion": descripcion,
        "recomendaciones": recomendaciones,
        "imagenUrl": imagenUrl ?? "", // se guarda la URL de la imagen subida
        "fecha": DateTime.now(),
      });
      final idUser = await LocalStorage.getIdUser();
      final allUsers = await _firestore.collection("users").get();
      if (allUsers.docs.isNotEmpty) {
        for (var i = 0; i < allUsers.docs.length; i++) {
          if (allUsers.docs[i]['uid'] != idUser) {
            final String? idDevice = allUsers.docs[i]["tokenDevice"];
            if (idDevice != null) {
              await PushMessageRepository().sendPushMessage(
                token: idDevice,
                body: "Se agrego un nuevo producto",
                title: "Prodcuto nuevo agregado $nameProduct",
                urlImage: imagenUrl,
              );
            }
          }
        }
      }

      onSuccess();
    } catch (e) {
      print(e);
      onError('Ha ocurrido un error durante la publicación');
    }
  }

//SELECIONAR LA IMAGEN
  Future<void> pickImage(BuildContext context, int imageIndex) async {
    final pickedFile = await showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.oscureColorb,
          title: const Text(
            'Seleccionar imagen:',
            style: TextStyle(
              color: AppColors.colorAcento,
              fontFamily: "MonB",
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(height: 10),
                MaterialButton(
                  color: AppColors.blueAcents,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  splashColor: AppColors.colorAcento.withOpacity(0.8),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_rounded, color: AppColors.text),
                      SizedBox(width: 15),
                      Text(
                        'Galería',
                        style: TextStyle(
                          color: AppColors.oscureColorb,
                          fontFamily: "MonB",
                          fontSize: 20,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      final croppedFile = await ImageCropper().cropImage(
                        sourcePath: pickedFile.path,
                        compressFormat: ImageCompressFormat.png,
                        compressQuality: 90,
                        aspectRatioPresets: [
                          CropAspectRatioPreset.square,
                          CropAspectRatioPreset.ratio3x2,
                          CropAspectRatioPreset.original,
                          CropAspectRatioPreset.ratio4x3,
                          CropAspectRatioPreset.ratio16x9
                        ],
                        uiSettings: [
                          AndroidUiSettings(
                            toolbarTitle: 'Editar imagen',
                            toolbarColor: AppColors.oscureColor,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: false,
                          ),
                          IOSUiSettings(
                            minimumAspectRatio: 1.0,
                          ),
                        ],
                      );
                      if (croppedFile != null) {
                        final newFile = File(croppedFile.path);
                        Navigator.pop(context, newFile);
                        switch (imageIndex) {
                          case 1:
                            _image = newFile;
                            break;
                        }
                        notifyListeners();
                      }
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                MaterialButton(
                  color: AppColors.colorAcento.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  splashColor: AppColors.blueAcents,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_rounded, color: AppColors.text),
                      SizedBox(width: 15),
                      Text(
                        'Cámara',
                        style: TextStyle(
                          color: AppColors.oscureColorb,
                          fontFamily: "MonB",
                          fontSize: 20,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      final croppedFile = await ImageCropper().cropImage(
                        sourcePath: pickedFile.path,
                        compressFormat: ImageCompressFormat.png,
                        compressQuality: 90,
                        aspectRatioPresets: [
                          CropAspectRatioPreset.square,
                          CropAspectRatioPreset.ratio3x2,
                          CropAspectRatioPreset.original,
                          CropAspectRatioPreset.ratio4x3,
                          CropAspectRatioPreset.ratio16x9
                        ],
                        uiSettings: [
                          AndroidUiSettings(
                            toolbarTitle: 'Editar imagen',
                            toolbarColor: AppColors.oscureColor,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: false,
                          ),
                          IOSUiSettings(
                            minimumAspectRatio: 1.0,
                          ),
                        ],
                      );
                      if (croppedFile != null) {
                        final newFile = File(croppedFile.path);
                        Navigator.pop(context, newFile);
                        switch (imageIndex) {
                          case 1:
                            _image = newFile;
                            break;
                        }
                        notifyListeners();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedFile != null) {
      final newFile = File(pickedFile.path);
      switch (imageIndex) {
        case 1:
          _image = newFile;
          break;
      }
      notifyListeners();
    }
  }
}
