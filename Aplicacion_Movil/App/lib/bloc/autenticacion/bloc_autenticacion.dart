import 'package:flutter_bloc/flutter_bloc.dart';
import 'eventos_autenticacion.dart';
import 'estados_autenticacion.dart';
import 'server/auth_service.dart';

class AutenticacionBloc
    extends Bloc<AutenticacionEventos, Autenticacionestados> {
  final AuthService authService = AuthService();

  AutenticacionBloc() : super(AutenticacionInicial()) {
    on<RevisarSesion>((event, emit) async {
      final user = await authService.obtenerSesion();
      if (user != null) {
        emit(LoginExitoso(user));
      } else {
        emit(AutenticacionInicial());
      }
    });

    on<Ingresar>((event, emit) async {
      emit(Logincargando());

      final res = await authService.login(event.usuario, event.password);

      if (res['status'] == 'success') {
        await authService.guardarSesion(res['user']);
        emit(LoginExitoso(res['user']));
      } else {
        emit(LoginError(res['message'] ?? "Error desconocido"));
      }
    });

    on<RegistrarUsuario>((event, emit) async {
      emit(Registrocargando());

      final res = await authService.registrar(event.usuario, event.email, event.password);

      if (res['status'] == 'success' || res['status'] == 201) {
        emit(RegistroExitoso());
      } else {
        emit(LoginError(res['message'] ?? "Error en el registro"));
      }
    });

    on<Salir>((event, emit) async {
      await authService.cerrarSesion();
      emit(AutenticacionInicial());
    });
  }
}