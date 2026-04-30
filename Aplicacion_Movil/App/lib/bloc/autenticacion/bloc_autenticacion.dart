import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'eventos_autenticacion.dart';
import 'estados_autenticacion.dart';
import 'server/auth_service.dart';

class AutenticacionBloc extends Bloc<AutenticacionEventos, Autenticacionestados> {
  final AuthService authService = AuthService();

  AutenticacionBloc() : super(AutenticacionInicial()) {

    on<Ingresar>((event, emit) async {
      emit(Logincargando());
      final res = await authService.login(event.usuario, event.password);
      
      if (res['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        
        emit(LoginExitoso(res['user']));
      } else {
        emit(LoginError(res['message'] ?? "Error desconocido"));
      }
    });

    on<CerrarSesion>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(AutenticacionInicial());
    });
  }
}