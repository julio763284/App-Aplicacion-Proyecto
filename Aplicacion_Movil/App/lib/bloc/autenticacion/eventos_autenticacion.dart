abstract class Autenticacion_Event {}

class Ingresar extends Autenticacion_Event {
  final String usuario;
  final String password;

  Ingresar(this.usuario, this.password);
}

class EventoRegistrarse extends Autenticacion_Event {
  // aquí puedes agregar los datos necesarios para registrar
}

class EventoOlvidarContrasena extends Autenticacion_Event {
  final String email; // normalmente necesitas un email para recuperar
  EventoOlvidarContrasena(this.email);
}
