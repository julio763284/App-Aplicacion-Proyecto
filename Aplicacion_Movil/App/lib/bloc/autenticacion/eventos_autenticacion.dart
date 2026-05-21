abstract class AutenticacionEventos {}

class Ingresar extends AutenticacionEventos {
  final String usuario;
  final String password;
  Ingresar(this.usuario, this.password);
}

class RegistrarUsuario extends AutenticacionEventos {
  final String usuario;
  final String email;
  final String password;
  RegistrarUsuario(this.usuario, this.email, this.password);
}

class RevisarSesion extends AutenticacionEventos {}

class Salir extends AutenticacionEventos {}
