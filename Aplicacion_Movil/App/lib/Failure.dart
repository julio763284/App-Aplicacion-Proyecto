import 'package:flutter/material.dart';

class VistaError extends StatelessWidget {
  final VoidCallback? alReintentar;

  const VistaError({super.key, this.alReintentar});

  @override
  Widget build(BuildContext context) {
    const Color colorPrimario = Color.fromARGB(255, 1, 122, 116);

    return Scaffold(
      backgroundColor: colorPrimario,
      body: Center(
        child: Container(
          width: 280, // Ancho fijo para que se vea más pequeño y compacto
          padding: const EdgeInsets.all(25.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 60, color: colorPrimario),
              const SizedBox(height: 15),
              const Text(
                "¡UPS! ERROR",
                style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 25),
              // BOTÓN PERSONALIZADO Y PEQUEÑO
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: alReintentar ?? () {},
                  borderRadius: BorderRadius.circular(15),
                  splashColor: colorPrimario.withOpacity(0.3),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorPrimario, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      "REINTENTAR",
                      style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}