import 'package:flutter/material.dart';

class Nuevocliente extends StatefulWidget {
  const Nuevocliente({super.key});

  @override
  State<Nuevocliente> createState() => _NuevoclienteState();
}
//animacion
class _NuevoclienteState extends State<Nuevocliente>

    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  InputDecoration estiloCampo(String texto, IconData icono) {
    const colorPrincipal = Color.fromARGB(255, 1, 122, 116);

    return InputDecoration(
      labelText: texto,
      labelStyle: const TextStyle(
        color: colorPrincipal,
        fontWeight: FontWeight.bold,
      ),
      suffixIcon: Icon(icono, color: colorPrincipal),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: colorPrincipal, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
    );
  }

  Widget campo(String texto, IconData icono) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        validator: (value) =>
            value == null || value.isEmpty ? 'Campo obligatorio' : null,
        decoration: estiloCampo(texto, icono),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const colorPrincipal = Color.fromARGB(255, 1, 122, 116);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo cliente"),
        backgroundColor: colorPrincipal,
      ),

      //  Botón fijo abajo
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrincipal,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cliente guardado')),
              );
            }
          },
          child: const Text("Guardar Cliente",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
//opciones del formulario
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                campo("Nombre", Icons.person),
                campo("Dirección", Icons.location_on),
                campo("Correo electrónico", Icons.email),
                campo("Número de teléfono", Icons.add_ic_call),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}