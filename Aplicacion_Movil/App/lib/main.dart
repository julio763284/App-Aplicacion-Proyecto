import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:gestor/HomePage2.dart';
import 'package:gestor/Presentacion/Pages/LoginHome.dart';
import 'package:gestor/bloc/autenticacion/bloc_autenticacion.dart';
import 'package:gestor/bloc/autenticacion/eventos_autenticacion.dart';
import 'package:gestor/bloc/autenticacion/estados_autenticacion.dart';
import 'package:gestor/Presentacion/core/theme_provider.dart';
import 'package:gestor/Presentacion/core/app_theme.dart';

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
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.temaClaro,
              darkTheme: AppTheme.temaOscuro,
              themeMode: themeProvider.themeMode,
              home: BlocBuilder<AutenticacionBloc, Autenticacionestados>(
                builder: (context, state) {
                  if (state is LoginExitoso) {
                    return const Homepage2();
                  }
                  return const LoginPage();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}