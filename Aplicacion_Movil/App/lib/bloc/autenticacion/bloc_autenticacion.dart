import 'package:flutter_bloc/flutter_bloc.dart';
import 'eventos_autenticacion.dart';
import 'estados_autenticacion.dart';
import 'server/auth_service.dart'; // Verifica que esta ruta sea correcta

class AutenticacionBloc extends Bloc<AutenticacionEventos, Autenticacionestados> {
  final AuthService authService = AuthService();

  AutenticacionBloc() : super(AutenticacionInicial()) {
    on<Ingresar>((event, emit) async {
      emit(Logincargando());
      
      final res = await authService.login(event.usuario, event.password);
      
      if (res['status'] == 'success') {
        emit(LoginExitoso(res['user']));
      } else {
        emit(LoginError(res['message'] ?? "Error desconocido"));
      }
    });
  }
}