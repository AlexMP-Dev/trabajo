class ProductMedicine {
  String uid;
  String nameProduct;
  String nameNegocio;
  String nameTipoCategory;
  String nameCategory;
  String nameColectionFinal;
  String cantidad;
  String precio;
  String categoria;
  String imagenUrl;
  DateTime fecha;

  String descripcion;
  String recomendaciones;

  ProductMedicine({
    required this.uid,
    required this.nameProduct,
    required this.nameNegocio,
    required this.nameTipoCategory,
    required this.nameCategory,
    required this.nameColectionFinal,
    required this.precio,
    required this.categoria,
    required this.fecha,
    required this.imagenUrl,
    required this.cantidad,
    required this.descripcion,
    required this.recomendaciones,
  });

  // // Métodos para convertir de/to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nameProduct': nameProduct,
      'nameNegocio': nameNegocio,
      'nameTipoCategory': nameTipoCategory,
      'nameCategory': nameCategory,
      'nameColectionFinal': nameColectionFinal,
      'fecha': fecha,
      'imagenUrl': imagenUrl,
      'cantidad': cantidad,
      'precio': precio,
      'categoria': categoria,
      'descripcion': descripcion,
      'recomendaciones': recomendaciones,
    };
  }

  static ProductMedicine fromMap(Map<String, dynamic> map) {
    return ProductMedicine(
      uid: map['uid'],
      nameProduct: map['nameProduct'],
      nameNegocio: map['nameNegocio'],
      nameTipoCategory: map['nameTipoCategory'],
      nameCategory: map['nameCategory'],
      nameColectionFinal: map['nameColectionFinal'],
      precio: map['precio'],
      categoria: map['categoria'],
      imagenUrl: map['imagenUrl'],
      fecha: map['fecha'],
      cantidad: map['cantidad'],
      descripcion: map['descripcion'],
      recomendaciones: map['recomendaciones'],
    );
  }
}
