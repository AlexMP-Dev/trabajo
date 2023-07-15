import 'dart:io';

import 'package:delivery_master2/src/provider/post_provider.dart';
import 'package:delivery_master2/src/utils/app_colors.dart';
import 'package:delivery_master2/src/utils/circularprogress_widget.dart';
import 'package:delivery_master2/src/utils/input_decoration_widget.dart';
import 'package:delivery_master2/src/utils/input_drowbuttom_widget.dart';
import 'package:delivery_master2/src/utils/utils_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPostProductos extends StatefulWidget {
  const AddPostProductos({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddPostProductosState createState() => _AddPostProductosState();
}

class _AddPostProductosState extends State<AddPostProductos> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _recomendacionesController =
      TextEditingController();

  String? _selectedCantidad;
//DATOS PARA EL DROWBUTTOM
  String? selectedNegocio;
  String? selectedSubcoleccion;
  String? selectedDocumento;
  String? selectedSubcoleccionDocumento;

  List<String> negocios = [];
  List<String> documentos = [];
  List<String> subcolecciones = [];
  List<String> servicios = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getNegocios();
  }

  Future<void> getNegocios() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Negocios').get();
    setState(() {
      negocios = querySnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> getSubcoleccionesProductos() async {
    if (selectedNegocio != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Negocios')
          .doc(selectedNegocio)
          .collection("Categorias")
          .get();
      setState(() {
        subcolecciones = querySnapshot.docs.map((doc) => doc.id).toList();
        //selectedSubcoleccion = null;
        //selectedSubcoleccionDocumento = null;
      });
    }
  }

  Future<void> getSubcoleccionesServicios() async {
    if (selectedNegocio != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Negocios')
          .doc(selectedNegocio)
          .collection("Servicios")
          .get();
      setState(() {
        subcolecciones = querySnapshot.docs.map((doc) => doc.id).toList();
        //selectedSubcoleccion = null;
        //selectedSubcoleccionDocumento = null;
      });
    }
  }

  Future<void> getDocumentos() async {
    if (selectedNegocio != null && selectedSubcoleccion != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Negocios')
          .doc(selectedNegocio)
          .collection(selectedSubcoleccion!)
          .doc(selectedSubcoleccionDocumento)
          .collection('Productos')
          .get();
      setState(() {
        documentos = querySnapshot.docs.map((doc) => doc.id).toList();
        //selectedDocumento = null;
        //selectedSubcoleccionDocumento = null;
      });
    }
  }

  Future<void> getDocumentosOption() async {
    if (selectedNegocio != null && selectedSubcoleccion != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Negocios')
          .doc(selectedNegocio)
          .collection(selectedSubcoleccion!)
          .doc(selectedSubcoleccionDocumento)
          .collection('Servicios')
          .get();
      setState(() {
        documentos = querySnapshot.docs.map((doc) => doc.id).toList();
        //selectedDocumento = null;
        //selectedSubcoleccionDocumento = null;
      });
    }
  }

//ENVIAR A LA BASE DE DATOS
  Future<void> _submitForm() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final File? image = postProvider.image;

    try {
      await postProvider.postMascotas(
        image: image,
        nameProduct: _nombreController.text,
        uid: "",
        username: _usuarioController.text,
        precio: _precioController.text,
        cantidad: _cantidadController.text,
        descripcion: _descripcionController.text,
        recomendaciones: _recomendacionesController.text,
        nameNegocio: selectedNegocio!,
        nameTipoCategory: selectedSubcoleccion!,
        nameCategory: selectedDocumento!,
        nameColectionFinal: selectedSubcoleccionDocumento!,
        onSuccess: () {
          setState(() {
            _isLoading = false;
          });
          showSnackbar2(context, "Tu publicación fue enviada");
          Navigator.of(context).pop();
        },
        onError: (String error) {
          showSnackbar2(context, error);
        },
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
      setState(() {
        _isLoading = false;
      });
      showSnackbar2(context, "Ha ocurrido un error durante la publicación");
    }
  }

  List<String> opcionesCantidad = [
    'Ilimitado',
    'Limitado',
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '100',
  ];
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.oscureColor,
        title: const Text('Agregar nueva mascota',
            style: TextStyle(fontFamily: "MonB", fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 400,
                      child: _buildImageCard(
                        postProvider,
                        postProvider.image,
                        "Seleccionar Imagen 1",
                        () => postProvider.pickImage(context, 1),
                      ),
                    ),
                    MaterialButton(
                      color: AppColors.oscureColor,
                      child: const Text(
                        "Seleccionar Imagen",
                        style: TextStyle(color: AppColors.text),
                      ),
                      onPressed: () => postProvider.pickImage(context, 1),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                      "Primero elige las imagenes y después la categoria, así las imagenes se mostrarán.",
                      style: TextStyle(
                          fontFamily: "MonB", color: AppColors.oscureColor),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: 15),
                //AQUI LOS DROWBUTTOMFORMFIELD
                InputDropdownButtonWidget(
                  labelText: "Negocio",
                  value: selectedNegocio,
                  items: negocios.map((negocio) {
                    return DropdownMenuItem<String>(
                      value: negocio,
                      child: Text(negocio),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedNegocio = value;
                      selectedSubcoleccion = null;
                      selectedDocumento = null;
                      selectedSubcoleccionDocumento = null;
                      if (value == "Categorias") {
                        selectedSubcoleccion =
                            "Categorias"; // Asignar directamente la selección en el segundo DropdownButtonFormField
                        getSubcoleccionesProductos();
                      } else if (value == "Servicios") {
                        selectedSubcoleccion =
                            "Servicios"; // Asignar directamente la selección en el segundo DropdownButtonFormField
                        getSubcoleccionesServicios();
                      }
                    });
                  },
                ),

                if (selectedNegocio != null) const SizedBox(height: 10),
                if (selectedNegocio != null)
                  InputDropdownButtonWidget(
                    labelText: 'Subcolección',
                    value: selectedSubcoleccion,
                    items:
                        <String>['Categorias', 'Servicios'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubcoleccion = value;
                        selectedDocumento = null;
                        selectedSubcoleccionDocumento = null;
                        if (value == "Categorias") {
                          getSubcoleccionesProductos();
                        } else if (value == "Servicios") {
                          getSubcoleccionesServicios();
                        }
                      });
                    },
                  ),

                if (selectedSubcoleccion != null) const SizedBox(height: 10),
                if (selectedSubcoleccion != null)
                  InputDropdownButtonWidget(
                    labelText: "Categoria",
                    value: selectedDocumento,
                    items: (selectedSubcoleccion == 'Categorias')
                        ? subcolecciones.map((subcoleccion) {
                            return DropdownMenuItem<String>(
                              value: subcoleccion,
                              child: Text(subcoleccion),
                            );
                          }).toList()
                        : (selectedSubcoleccion == 'Servicios')
                            ? subcolecciones.map((servicio) {
                                return DropdownMenuItem<String>(
                                  value: servicio,
                                  child: Text(servicio),
                                );
                              }).toList()
                            : [],
                    onChanged: (value) {
                      setState(() {
                        selectedDocumento = value;
                      });
                    },
                  ),
                if (selectedDocumento != null) const SizedBox(height: 10),
                if (selectedDocumento != null)
                  InputDropdownButtonWidget(
                    labelText: "Categoria final",
                    value: selectedSubcoleccionDocumento,
                    items: (selectedSubcoleccion == 'Categorias')
                        ? <String>['Productos'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()
                        : (selectedSubcoleccion == 'Servicios')
                            ? <String>['Servicios'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()
                            : [],
                    onChanged: (value) {
                      setState(() {
                        selectedSubcoleccionDocumento = value;
                        if (value == "Productos") {
                          getDocumentos();
                        } else if (value == "Servicios") {
                          getDocumentosOption();
                        }
                      });
                    },
                  ),

                const SizedBox(height: 16),
                InputDecorationWidget(
                  controller: _nombreController,
                  labelText: 'Nombre del producto',
                  hintText: "Nombre del producto",
                  keyboardType: TextInputType.name,
                  suffixIcon: const Icon(Icons.pets_rounded,
                      color: AppColors.oscureColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InputDecorationWidget(
                        controller: _precioController,
                        keyboardType: TextInputType.number,
                        hintText: "Precio del producto",
                        maxLines: TextField.noMaxLength,
                        labelText: 'Precio del Producto',
                        suffixIcon: const Icon(Icons.menu_book_rounded,
                            color: AppColors.oscureColor),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es requerido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InputDropdownButtonWidget(
                        labelText: "Cantidad",
                        value: _selectedCantidad,
                        onChanged: (value) {
                          setState(() {
                            _selectedCantidad = value;
                            _cantidadController.text = value!;
                          });
                        },
                        items: opcionesCantidad.map((String valor) {
                          return DropdownMenuItem<String>(
                            value: valor,
                            child: Text(valor),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es requerido';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                InputDecorationWidget(
                  controller: _descripcionController,
                  keyboardType: TextInputType.multiline,
                  hintText: "Describe tu producto",
                  maxLines: TextField.noMaxLength,
                  labelText: 'Describe tu producto',
                  suffixIcon: const Icon(Icons.menu_book_rounded,
                      color: AppColors.oscureColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InputDecorationWidget(
                  controller: _recomendacionesController,
                  maxLines: TextField.noMaxLength,
                  keyboardType: TextInputType.multiline,
                  hintText: "Recomendaciones para su cuidado",
                  labelText: 'Recomendaciones para su cuidado',
                  suffixIcon: const Icon(Icons.security_rounded,
                      color: AppColors.oscureColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _isLoading
                    ? const CircularProgressWidget(text: "Cargando..")
                    : MaterialButton(
                        color: AppColors.blueAcents,
                        child: const Text("Publicar",
                            style: TextStyle(color: AppColors.text)),
                        onPressed: () {
                          _submitForm();
                          // Cerrar el teclado
                          FocusScope.of(context).unfocus();
                          if (postProvider.image == null) {
                            // Si no se ha seleccionado una imagen, muestra un mensaje de error
                            setState(() {
                              postProvider.errorMessage =
                                  'Por favor, seleccione una imagen';
                            });
                            return;
                          }
                        },
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildImageCard(
    PostProvider postProvider, File? image, String text, Function() onTap) {
  return image != null
      ? Card(
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            height: 400,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.oscureColor,
                width: 4,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  image,
                  height: 400,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        )
      : Card(
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            height: 400,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.oscureColor,
                width: 4,
              ),
            ),
            child: InkWell(
                onTap: onTap, child: Image.asset("assets/images/noimage.png")),
          ),
        );
}
