// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:delivery_master2/src/pages/home_page.dart';
import 'package:delivery_master2/src/utils/app_colors.dart';
import 'package:delivery_master2/src/utils/circularprogress_widget.dart';
import 'package:delivery_master2/src/utils/input_decoration_widget.dart';
import 'package:delivery_master2/src/utils/utils_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/login_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final loginProvider = LoginProvider();

  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onFormSubmit(
    String usernameOrEmail,
    String password,
    BuildContext context,
  ) {
    final String usernameOrEmailLower = usernameOrEmail.toLowerCase();
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    setState(() {
      _isLoading = true; // Establecemos isLoading en true al inicio
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _formKey.currentState!.save();

    loginProvider.loginUser(
      usernameOrEmail: usernameOrEmailLower,
      password: password,
      onSuccess: () async {
        // Verificar si el usuario ha verificado su correo electrónico
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Obtener el rol del usuario desde la base de datos
          String? userRole = await loginProvider.getUserRol(user.email!);

          // Obtener el nombre de usuario desde la base de datos
          String? username = await loginProvider.getUsername(user.email!);

          // Mostrar el Snackbar de bienvenida con el nombre de usuario
          showSnackbar2(
            context,
            '¡Bienvenido, ${username ?? user.email}! Rol: $userRole',
          );

          // Redirigir al usuario a la página de inicio
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
        //else {
        //   // El usuario no ha verificado su correo electrónico, mostrar un mensaje de error
        //   showSnackbar2(context,
        //       "Debes verificar tu correo electrónico antes de iniciar sesión.");
        // }

        setState(() {
          // Establecer isLoading en false después de completar la operación de inicio de sesión
          _isLoading = false;
        });
      },
      onError: (error) {
        // Se produjo un error durante el inicio de sesión
        showSnackbar2(context, error);

        setState(() {
          _isLoading =
              false; // Establecer isLoading en false después de manejar el error
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicia Sesión"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 30),
                  InputDecorationWidget2(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    controller: _usernameOrEmailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Usuario o email',
                    labelText: 'Usuario o correo electrónico',
                    suffixIcon: const Icon(Icons.person_2_rounded,
                        color: AppColors.oscureColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  InputDecorationWidget2(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    controller: _passwordController,
                    obscureText: _isObscure,
                    hintText: "********",
                    labelText: 'Ingresar Contraseña',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.oscureColor),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es requerido';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 25),
                  _isLoading
                      ? const CircularProgressWidget(text: "Cargando")
                      : MaterialButton(
                          color: AppColors.blueAcents,
                          child: const Text("Iniciar sesión"),
                          onPressed: () {
                            String usernameOrEmail =
                                _usernameOrEmailController.text;
                            String password = _passwordController.text;
                            onFormSubmit(usernameOrEmail, password, context);
                            // Cerrar el teclado
                            FocusScope.of(context).unfocus();
                          }),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
