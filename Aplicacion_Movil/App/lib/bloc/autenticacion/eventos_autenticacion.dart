abstract class AutenticacionEventos {}

class Ingresar extends AutenticacionEventos {
  final String usuario;
  final String password;
  Ingresar(this.usuario, this.password);
}

class CerrarSesion extends AutenticacionEventos {}