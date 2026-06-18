import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor/bloc/autenticacion/bloc_autenticacion.dart';
import 'package:gestor/bloc/autenticacion/eventos_autenticacion.dart';
import 'package:gestor/bloc/autenticacion/estados_autenticacion.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool arePasswordsVisible = false;
  bool hasUpper = false;
  bool hasLower = false;
  bool hasSpecial = false;
  bool hasMinLength = false;

  final Color accentColor = const Color(0xFF00FBFF);

  void _validatePassword(String value) {
    setState(() {
      hasUpper = value.contains(RegExp(r'[A-Z]'));
      hasLower = value.contains(RegExp(r'[a-z]'));
      hasSpecial = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      hasMinLength = value.length >= 6;
    });
  }

  void validarYRegistrar() {
    if (nombreController.text.isEmpty ||
        correoController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showNexusAlert(
        "RELLENE TODOS LOS CAMPOS",
        Colors.orange,
        Icons.warning_amber_rounded,
      );
      return;
    }

    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(correoController.text);

    if (!emailValid) {
      _showNexusAlert(
        "EL FORMATO DE CORREO NO ES VÁLIDO",
        Colors.redAccent,
        Icons.email_outlined,
      );
      return;
    }

    if (!(hasUpper && hasLower && hasSpecial && hasMinLength)) {
      _showNexusAlert(
        "LA CONTRASEÑA NO CUMPLE LOS REQUISITOS",
        Colors.redAccent,
        Icons.lock_outline,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showNexusAlert(
        "LAS CONTRASEÑAS NO COINCIDEN",
        Colors.redAccent,
        Icons.lock_reset_rounded,
      );
      return;
    }

    context.read<AutenticacionBloc>().add(
      RegistrarUsuario(
        nombreController.text,
        correoController.text,
        passwordController.text,
      ),
    );
  }

  void _showNexusAlert(String message, Color color, IconData icon) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _NexusAlertWidget(
        message: message,
        color: color,
        icon: icon,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlayState.insert(overlayEntry);
  }

  Widget _validationRow(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            color: isValid ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isValid ? Colors.green : Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070F11),
      body: BlocConsumer<AutenticacionBloc, Autenticacionestados>(
        listener: (context, state) {
          if (state is RegistroExitoso) {
            _showNexusAlert(
              "¡BIENVENIDO A NEXUS!",
              Colors.greenAccent,
              Icons.verified_user_outlined,
            );
            Future.delayed(
              const Duration(seconds: 2),
              () => Navigator.pop(context),
            );
          }
          if (state is LoginError) {
            _showNexusAlert(
              state.mensaje.toUpperCase(),
              Colors.redAccent,
              Icons.gpp_bad_outlined,
            );
          }
        },
        builder: (context, state) {
          final bool cargando = state is Registrocargando;

          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomRight,
                radius: 1.5,
                colors: [accentColor.withOpacity(0.1), const Color(0xFF070F11)],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Icon(Icons.person_add_alt, size: 70, color: accentColor),
                      const SizedBox(height: 15),
                      const Text(
                        "UNIRSE A NEXUS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                              ),
                            ),
                            child: Column(
                              children: [
                                _field(
                                  nombreController,
                                  "Usuario",
                                  Icons.person_outline,
                                ),
                                const SizedBox(height: 20),
                                _field(
                                  correoController,
                                  "Email",
                                  Icons.alternate_email,
                                  type: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 20),
                                _field(
                                  passwordController,
                                  "Contraseña",
                                  Icons.lock_outline,
                                  isPass: true,
                                  obscure: !arePasswordsVisible,
                                  onToggleVisibility: () => setState(
                                    () => arePasswordsVisible =
                                        !arePasswordsVisible,
                                  ),
                                  onChanged: _validatePassword,
                                ),
                                const SizedBox(height: 20),
                                _field(
                                  confirmPasswordController,
                                  "Confirmar",
                                  Icons.shield_outlined,
                                  isPass: true,
                                  obscure: !arePasswordsVisible,
                                  onToggleVisibility: () => setState(
                                    () => arePasswordsVisible =
                                        !arePasswordsVisible,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _validationRow(
                                        "Mínimo 1 mayúscula",
                                        hasUpper,
                                      ),
                                      _validationRow(
                                        "Mínimo 1 minúscula",
                                        hasLower,
                                      ),
                                      _validationRow(
                                        "Mínimo 1 carácter especial",
                                        hasSpecial,
                                      ),
                                      _validationRow(
                                        "Mínimo 6 caracteres",
                                        hasMinLength,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 35),
                                ElevatedButton(
                                  onPressed: cargando
                                      ? null
                                      : validarYRegistrar,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accentColor,
                                    foregroundColor: Colors.black,
                                    minimumSize: const Size(
                                      double.infinity,
                                      55,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: cargando
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.black,
                                                ),
                                          ),
                                        )
                                      : const Text(
                                          "CREAR CUENTA",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "¿Ya tienes cuenta? ",
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Text(
                                        "Iniciar sesión",
                                        style: TextStyle(
                                          color: accentColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String h,
    IconData i, {
    bool isPass = false,
    bool obscure = true,
    TextInputType type = TextInputType.text,
    Function(String)? onChanged,
    VoidCallback? onToggleVisibility,
  }) {
    return TextField(
      controller: c,
      obscureText: isPass ? obscure : false,
      keyboardType: type,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: h,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        prefixIcon: Icon(i, color: accentColor, size: 20),
        suffixIcon: isPass
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white38,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _NexusAlertWidget extends StatefulWidget {
  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onDismiss;
  const _NexusAlertWidget({
    required this.message,
    required this.color,
    required this.icon,
    required this.onDismiss,
  });
  @override
  State<_NexusAlertWidget> createState() => _NexusAlertWidgetState();
}

class _NexusAlertWidgetState extends State<_NexusAlertWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeInBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 30,
      right: 30,
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.color.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(widget.icon, color: widget.color, size: 28),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
