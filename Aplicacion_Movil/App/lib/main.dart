import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor/Presentacion/Widgets/login.dart';
import 'package:gestor/Presentacion/Widgets/vistaDeRegistrarse.dart';
import 'package:gestor/bloc/autenticacion/bloc_autenticacion.dart';

void main() {
  runApp(const InventaryMobile());
}

class InventaryMobile extends StatelessWidget {
  const InventaryMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AutenticacionBloc())],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RegisterView(),
      ),
    );
  }
}
