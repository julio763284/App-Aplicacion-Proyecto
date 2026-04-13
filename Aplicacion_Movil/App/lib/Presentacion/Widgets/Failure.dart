import 'dart:ui';
import 'package:flutter/material.dart';

class VistaError extends StatelessWidget {
  final VoidCallback? alReintentar;

  const VistaError({super.key, this.alReintentar});

  @override
  Widget build(BuildContext context) {
    // Colores del sistema Nexus
    const Color primaryDark = Color(0xFF0D1B1E);
    const Color neonRed = Color(0xFFFF4B4B); // Rojo neón para errores

    return Scaffold(
      backgroundColor: primaryDark,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 280, // Mantengo tu ancho compacto
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05), // Efecto cristal oscuro
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                  color: neonRed.withOpacity(0.3), 
                  width: 1.5
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icono con resplandor neón
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: neonRed.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded, 
                      size: 60, 
                      color: neonRed
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "¡UPS! ERROR",
                    style: TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 18,
                      letterSpacing: 1.2
                    ),
                  ),
                  const SizedBox(height: 25),

                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: alReintentar ?? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Intentando de nuevo..."))
                        );
                      },
                      borderRadius: BorderRadius.circular(15),
                      splashColor: neonRed.withOpacity(0.3),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: neonRed.withOpacity(0.1),
                          border: Border.all(color: neonRed, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          "REINTENTAR",
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}