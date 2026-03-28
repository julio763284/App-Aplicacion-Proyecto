import 'package:flutter_bloc/flutter_bloc.dart';
import 'estados_autenticacion.dart';
import 'eventos_autenticacion.dart';

class AutenticacionBloc
    extends Bloc<Autenticacion_Event, Autenticacionestados> {
  AutenticacionBloc() : super(Login()) {
    on<Ingresar>((event, emit) async {
      emit(Logincargando());
      await Future.delayed(const Duration(seconds: 2));
      emit(LoginExitoso());
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
