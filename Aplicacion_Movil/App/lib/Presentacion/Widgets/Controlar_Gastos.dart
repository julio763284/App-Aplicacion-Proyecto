import 'package:flutter/material.dart';

class Controlar_Gastos extends StatelessWidget {
  const Controlar_Gastos({super.key});

  @override
  Widget build(BuildContext context) {
    // Definición de la paleta de colores estilo Neumórfico/Dark
    const primaryDark = Color(0xFF0D1B1E);
    const accentTeal = Color(0xFF017A74);
    const neonGreen = Color(0xFF00FFC2);

    return Scaffold(
      backgroundColor: primaryDark,
      appBar: AppBar(
        backgroundColor: accentTeal.withOpacity(0.15),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: neonGreen),
        title: const Text(
          "CONTROL DE GASTOS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // Forzamos a que el contenido mida al menos el alto de la pantalla
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                // Empuja el primer bloque arriba y el segundo (Balance) abajo
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- SECCIÓN SUPERIOR: ICONO Y MENSAJE ---
                  Column(
                    children: [
                      const SizedBox(height: 60), 
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: neonGreen.withOpacity(0.05),
                          shape: BoxShape.circle,
                          border: Border.all(color: neonGreen.withOpacity(0.1)),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 80,
                          color: neonGreen,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "SIN REGISTROS",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Presiona el botón + para añadir un gasto",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14, 
                            color: Colors.white.withOpacity(0.4)
                          ),
                        ),
                      ),
                    ],
                  ),

                  // --- SECCIÓN INFERIOR: PANEL DE BALANCE TOTAL ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "BALANCE TOTAL",
                                style: TextStyle(
                                  color: Colors.white38, 
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 12
                                ),
                              ),
                              Text(
                                "\$ 0.00",
                                style: TextStyle(
                                  color: neonGreen, 
                                  fontSize: 24, 
                                  fontWeight: FontWeight.bold, 
                                  fontFamily: 'monospace'
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: neonGreen,
        onPressed: () {
          // Lógica para agregar un nuevo gasto
          debugPrint("Añadir gasto presionado");
        },
        child: const Icon(Icons.add, color: primaryDark),
      ),
    );
  }
}