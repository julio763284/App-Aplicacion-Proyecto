import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/olvidar_contrasena2.dart';



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
                        if (phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Ingresa tu número de teléfono"),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const OlvidarContrasena2(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Enviar código",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),

                 const SizedBox(height: 15),

// 🔹 BOTÓN REENVIAR CÓDIGO
TextButton(
  onPressed: () {
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ingresa tu número para reenviar el código"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Código reenviado correctamente"),
        ),
      );

      // Aquí luego puedes agregar la lógica real para reenviar código
    }
  },
  child: const Text(
    "Reenviar código",
    style: TextStyle(
      color: Color.fromARGB(255, 1, 122, 116),
      fontWeight: FontWeight.bold,
    ),
  ),
),

const SizedBox(height: 5),

        TextButton(
        onPressed: () {
            Navigator.pop(context);
        },
        child: const Text(
            "Volver al Login",
            style: TextStyle(
            color: Color.fromARGB(255, 1, 122, 116),
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