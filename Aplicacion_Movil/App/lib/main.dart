import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor/HomePage2.dart';
import 'package:gestor/Presentacion/Pages/LoginHome.dart';
import 'package:gestor/bloc/autenticacion/bloc_autenticacion.dart';
import 'package:gestor/bloc/autenticacion/eventos_autenticacion.dart';
import 'package:gestor/bloc/autenticacion/estados_autenticacion.dart';

void main() {
  runApp(const InventaryMobile());
}

class InventaryMobile extends StatelessWidget {
  const InventaryMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AutenticacionBloc()..add(RevisarSesion()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AutenticacionBloc, Autenticacionestados>(
          builder: (context, state) {
            if (state is LoginExitoso) {
              return const Homepage2();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}