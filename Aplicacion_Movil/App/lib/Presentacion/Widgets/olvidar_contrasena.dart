import 'package:flutter/material.dart';

class OlvidarContrasenaPage extends StatefulWidget {
  const OlvidarContrasenaPage({super.key});

  @override
  State<OlvidarContrasenaPage> createState() =>
      _OlvidarContrasenaPageState();
}

class _OlvidarContrasenaPageState
    extends State<OlvidarContrasenaPage> {

  final TextEditingController phoneController =
      TextEditingController();
  final TextEditingController codeController =
      TextEditingController();
  final TextEditingController newPassController =
      TextEditingController();
  final TextEditingController confirmPassController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 1, 122, 116),
              Color.fromARGB(255, 0, 168, 150),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(25),
              width: 370,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(2, 6),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Icon(
                    Icons.lock_reset,
                    size: 90,
                    color: Color.fromARGB(255, 1, 122, 116),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Recuperar Contraseña",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 122, 116),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Teléfono
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Número de teléfono",
                      prefixIcon: const Icon(Icons.phone),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Código
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: "Código recibido",
                      prefixIcon: const Icon(Icons.verified),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Nueva contraseña
                  TextField(
                    controller: newPassController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Nueva contraseña",
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Confirmar contraseña
                  TextField(
                    controller: confirmPassController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirmar contraseña",
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 1, 122, 116),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        if (phoneController.text.isEmpty ||
                            codeController.text.isEmpty ||
                            newPassController.text.isEmpty ||
                            confirmPassController.text.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Completa todos los campos"),
                            ),
                          );
                        } else if (newPassController.text !=
                            confirmPassController.text) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Las contraseñas no coinciden"),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Contraseña actualizada correctamente"),
                            ),
                          );

                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Restablecer contraseña",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Volver al Login",
                      style: TextStyle(
                        color:
                            Color.fromARGB(255, 1, 122, 116),
                        fontWeight: FontWeight.bold,
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

