import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor/HomePage2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestor/Presentacion/Pages/LoginHome.dart';
import 'package:gestor/bloc/autenticacion/bloc_autenticacion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(InventaryMobile(inicioSesionActivo: isLoggedIn));
}

class InventaryMobile extends StatelessWidget {
  final bool inicioSesionActivo;

  const InventaryMobile({super.key, required this.inicioSesionActivo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AutenticacionBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: inicioSesionActivo ? const Homepage2() : const LoginPage(),
      ),
    );
  }
}