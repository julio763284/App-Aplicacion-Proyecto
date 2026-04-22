import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fondo semi-transparente para que se vea lo que hay detrás
      color: Colors.black.withOpacity(0.5), 
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
          children: [
            // Círculo de carga pequeño y blanco
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3, // Grosor del círculo
              ),
            ),
            const SizedBox(height: 15),
            // Texto "Cargando..."
            Text(
              "Cargando...",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                letterSpacing: 1.2,
                decoration: TextDecoration.none, // Quita la línea amarilla de debug
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}