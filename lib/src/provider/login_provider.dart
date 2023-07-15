// ignore_for_file: unused_local_variable

import 'package:delivery_master2/src/services/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  notAuthenticated,
  checking,
  authenticated,
}

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthStatus authStatus = AuthStatus.notAuthenticated;

  String? _errorMessage;
  String get errorMessage => _errorMessage ?? '';

  bool obscureText = true;

  bool isLoggedIn = false;

  Future<void> loginUser({
    required String usernameOrEmail,
    required String password,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      authStatus = AuthStatus.checking;
      final String usernameOrEmailLower = usernameOrEmail.toLowerCase();

      final QuerySnapshot result = await _firestore.collection('users').where('username_lowercase', isEqualTo: usernameOrEmailLower).limit(1).get();

      if (result.docs.isNotEmpty) {
        final String email = result.docs.first.get('email');

        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        debugPrint("USER ::: : :: $userCredential");

        checkAuthStatus();
        onSuccess();
        return;
      }

      final QuerySnapshot resultEmail = await _firestore.collection('users').where('email', isEqualTo: usernameOrEmailLower).limit(1).get();

      if (resultEmail.docs.isNotEmpty) {
        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: resultEmail.docs.first.get('email'),
          password: password,
        );
        checkAuthStatus();
        onSuccess();
        return;
      }

      onError('No se encontró un usuario con ese nombre o correo electrónico');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        onError('Nombre de usuario o contraseña incorrectos');
      } else {
        onError('Ha ocurrido un error durante el inicio de sesión');
      }
    } catch (e) {
      onError('Ha ocurrido un error durante el inicio de sesión');
    }
  }

  //VERIFICA SI EL NOMBRE DE USUARIO YA SE ENCUENTRA EN LA BASE DE DATOS
  Future<bool> checkUsernameExistsLogin(String username) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username.toLowerCase()).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  //VERIFICA SI EL EMAIL YA SE ENCUENTRA EN LA BASE DE DATOS
  Future<bool> checkEmailExistsLogin(String email) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email.toLowerCase()).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

//VERIFICAR AUTENTICIDAD DEL ROL
  Future<void> checkAuthStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    isLoggedIn = user != null;

    if (isLoggedIn) {
      final tokenResult = await user!.getIdTokenResult();
      try {
        final decodedToken = tokenResult.claims;
        final rol = decodedToken!['rol'];
        LocalStorage.saveIdUser(user.uid);

        // Verificar permisos de usuario según las reglas de Firestore
        final firestore = FirebaseFirestore.instance;
        final userDoc = firestore.collection('users').doc(user.uid);
        final userDocSnapshot = await userDoc.get();
        final userDocData = userDocSnapshot.data();
        final userRol = userDocData?['rol'];

        if (userRol == 'admin' || userRol == 'manager') {
          // El usuario tiene permisos de administrador o manager, puede hacer lo que quiera
        } else if (userRol == 'user') {
          // El usuario tiene permisos de usuario, puede leer pero no escribir
          // en las colecciones según las reglas de Firestore
        } else {
          // El usuario no tiene un rol válido, cerrar sesión
          FirebaseAuth.instance.signOut();
        }
      } catch (e) {
        // Aquí puedes hacer algo en caso de un error al verificar el token, como cerrar la sesión del usuario.
      }
    }
  }

  void getObscureText() {
    obscureText == true ? obscureText = false : obscureText = true;
    notifyListeners();
  }

  //SALIR DE LA APP

  Future<void> logoutApp() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _auth.signOut();
    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
    isLoggedIn = false;
    s.clear();
  }

//PARA VERIFICAR EL ROL DEL USUARIO
  Future<String?> getUserRol(String usernameOrEmail) async {
    final String usernameOrEmailLower = usernameOrEmail.toLowerCase();

    final userDocs = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: usernameOrEmailLower).get();

    if (userDocs.docs.isNotEmpty) {
      return userDocs.docs.first.get('rol');
    }

    final emailDocs = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: usernameOrEmailLower).get();

    if (emailDocs.docs.isNotEmpty) {
      return emailDocs.docs.first.get('rol');
    }
    return null;
  }

//PARA MOSTRAR EL NOMBRE SE USUARIO CUANDO INICIA SESION
  Future<String?> getUsername(String email) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      final userData = snapshot.docs[0].data();
      return userData['username'] as String?;
    }

    return null;
  }
}
