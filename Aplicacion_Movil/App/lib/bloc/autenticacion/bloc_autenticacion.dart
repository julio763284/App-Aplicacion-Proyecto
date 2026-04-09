import 'package:flutter_bloc/flutter_bloc.dart';
import 'estados_autenticacion.dart';
import 'eventos_autenticacion.dart';
import 'server/auth_service.dart';

class AutenticacionBloc extends Bloc<Autenticacion_Event, Autenticacionestados> {
  final AuthService authService = AuthService();

  AutenticacionBloc() : super(Login()) {
    on<Ingresar>((event, emit) async {
      emit(Logincargando());
      bool exito = await authService.validarLogin(event.usuario, event.password);
      if (exito) {
        emit(LoginExitoso());
      } else {
        emit(LoginError());
      }
    });

    on<EventoRegistrarse>((event, emit) async {
      emit(Logincargando());
      await Future.delayed(const Duration(seconds: 2));
      emit(Estado_Registrarse());
    });

    on<EventoOlvidarContrasena>((event, emit) async {
      emit(Logincargando());
      await Future.delayed(const Duration(seconds: 2));
      emit(EstadoOlvidarcontrasena());
    });
  }
}