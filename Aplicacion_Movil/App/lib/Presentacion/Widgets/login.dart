import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor/HomePage2.dart'; 
import 'package:gestor/Presentacion/Pages/LoginHome.dart'; 
import 'package:gestor/Presentacion/Widgets/Loading.dart';
import 'package:gestor/Presentacion/Widgets/vistaDeRegistrarse.dart';
import 'package:gestor/bloc/autenticacion/bloc_autenticacion.dart';
import 'package:gestor/bloc/autenticacion/estados_autenticacion.dart';
import 'package:gestor/Presentacion/Widgets/olvidar_contrasena.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E), 
      body: BlocListener<AutenticacionBloc, Autenticacionestados>(
        listener: (context, state) {
          if (state is Estado_Registrarse) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterView()),
            );
          } else if (state is EstadoOlvidarcontrasena) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OlvidarContrasenaPage()),
            );
          }
        },
        child: BlocBuilder<AutenticacionBloc, Autenticacionestados>(
          builder: (context, state) {
            
            if (state is Logincargando) {
              return const LoadingView();
            } 
            
            if (state is LoginExitoso) {
              return const Homepage2(); 
            } 

            return LoginHome( 
              userController: userController,
              passController: passController,
            );
          },
        ),
      ),
    );
  }
}