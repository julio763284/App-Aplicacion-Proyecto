import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor/HomePage.dart';
import 'package:gestor/Presentacion/Widgets/Failure.dart';
import 'package:gestor/HomePage.dart';
import 'package:gestor/Presentacion/Widgets/Controlar_Gastos.dart';
import 'package:gestor/Presentacion/Widgets/Proveedores.dart';
import 'package:gestor/Presentacion/Widgets/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Widgets/Configuracion.dart';
import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';
import 'package:gestor/Presentacion/Widgets/api.dart';
import 'package:gestor/Presentacion/Widgets/notificationView.dart';
import 'package:gestor/Presentacion/Widgets/vistaDeRegistrarse.dart';
import 'package:gestor/Presentacion/Widgets/login.dart';
import 'package:gestor/Presentacion/Widgets/olvidar_contrasena.dart';
import 'package:gestor/Presentacion/Widgets/olvidar_contrasena2.dart';
import 'package:gestor/Presentacion/Widgets/Cliente.dart';
import 'package:gestor/Presentacion/Widgets/gestionar_inventario.dart';
import 'package:gestor/Presentacion/Widgets/vista_logo.dart';
import 'package:gestor/bloc/autenticacion/bloc_autenticacion.dart';

void main() {
  runApp(const InventaryMobile());
}

class InventaryMobile extends StatelessWidget {
  const InventaryMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AutenticacionBloc()),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false,
       home: LoginPage()),
    );
  }
}

