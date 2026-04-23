abstract class Autenticacionestados {}

class AutenticacionInicial extends Autenticacionestados {}
class Logincargando extends Autenticacionestados {}
class LoginExitoso extends Autenticacionestados {
  final Map user;
  LoginExitoso(this.user);
}
class LoginError extends Autenticacionestados {
  final String mensaje; 
  LoginError(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}
// Estados para navegación que usas en tu listener
class Estado_Registrarse extends Autenticacionestados {}
class EstadoOlvidarcontrasena extends Autenticacionestados {}