class AccountPageModel {
  String username;
  String email;
  String password;
  String birth;
  String edad;
  String telefono;
  String rol;
  String token;
  String biografia;
  String ciudad;
  String departamento;
  String imageUrl;
  dynamic createdAt;
  String uid;

  AccountPageModel({
    required this.username,
    required this.email,
    required this.edad,
    required this.password,
    required this.birth,
    required this.token,
    required this.rol,
    required this.telefono,
    required this.createdAt,
    required this.biografia,
    required this.ciudad,
    required this.departamento,
    required this.imageUrl,
    required this.uid,
   
  });
  //bool get isAdmin => roles != null && roles!.contains('admin');

  factory AccountPageModel.fromJson(Map<String, dynamic> json) {
    return AccountPageModel(
      username: json['username'].toString(),
      email: json['email'].toString(),
      birth: json['birth'].toString(),
      telefono: json['telefono'].toString(),
      password: json['password'],
      biografia: json['biografia'].toString(),
      edad: json['edad'].toString(),
      ciudad: json['ciudad'].toString(),
      departamento: json['departamento'].toString(),
      rol: json['rol'],
      token: json['token'],
      createdAt: json['createdAt'],
      imageUrl: json['imageUrl'],
      uid: json['uid'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['birth'] = birth;
    data['password'] = password;
    data['edad'] = edad;
    data['rol'] = rol;
    data['token'] = token;
    data['createdAt'] = createdAt;
    data['biografia'] = biografia;
    data['telefono'] = telefono;
    data['ciudad'] = ciudad;
    data['departamento'] = departamento;
    data['imageUrl'] = imageUrl;
    data['uid'] = uid;
   
    return data;
  }

}
