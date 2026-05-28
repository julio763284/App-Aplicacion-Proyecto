import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/core/config.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestor/Presentacion/Pages/LoginHome.dart';
import 'package:flutter/services.dart';

class PerfilPage extends StatefulWidget {
  final int userId;
  const PerfilPage({super.key, required this.userId});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String nombre = "";
  String email = "";
  String? urlImagen;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    obtenerPerfil();
  }

  Future<void> obtenerPerfil() async {
    try {
      final String endpoint = ApiConfig.url('perfil?id=${widget.userId}');
      final res = await http.get(Uri.parse(endpoint));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          nombre = data['nombre'] ?? "";
          email = data['correo'] ?? "";
          urlImagen = data['imagen'];
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<void> subirImagen() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    File file = File(image.path);
    List<int> bytes = await file.readAsBytes();
    String base64Image = base64Encode(bytes);

    try {
      final String endpoint = ApiConfig.url('subir_imagen');
      final res = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": widget.userId, "imagen": base64Image}),
      );
      if (res.statusCode == 200) obtenerPerfil();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D1B1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              "Cerrar sesión",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          "¿Estás seguro de que deseas cerrar sesión?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sí, salir"),
          ),
        ],
      ),
    );
    if (confirmed == true) await logout();
  }

  Future<void> _eliminarImagen() async {
    try {
      final String endpoint = ApiConfig.url('eliminar_imagen');
      final res = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": widget.userId}),
      );

      if (res.statusCode == 200) {
        setState(() {
          urlImagen = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto de perfil eliminada exitosamente'),
            ),
          );
        }
      }
    } catch (e) {
      print("Error al eliminar imagen: $e");
    }
  }

  // --- VISOR DE FOTO MEJORADO CON EL DISEÑO DE LA APP ---
  void _verFotoEnGrande() {
    if (urlImagen == null || urlImagen!.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D1B1E), Color(0xFF050A0B)], // Fondo integrado
            ),
          ),
          child: Stack(
            children: [
              // Contenedor interactivo con marco brillante
              Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.15),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.memory(
                        base64Decode(urlImagen!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              // Botón de cerrar estilizado
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.cyanAccent,
                        size: 28,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: Colors.cyanAccent.withOpacity(0.2),
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D1B1E),
        body: Center(
          child: CircularProgressIndicator(color: Colors.cyanAccent),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PERFIL",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            color: const Color(0xFF1A2A2D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'editar') {
                _editarPerfil();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'editar',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: Colors.cyanAccent,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Actualizar perfil',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1B1E), Color(0xFF050A0B)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildAvatar(),
                        const SizedBox(height: 20),
                        Text(
                          nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 40),
                        _cardInfo(
                          Icons.email_outlined,
                          "Correo electrónico",
                          email,
                        ),
                        _cardInfo(
                          Icons.person_outline,
                          "Nombre de usuario",
                          nombre,
                        ),
                        const Spacer(),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.withOpacity(0.9),
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          onPressed: _confirmLogout,
                          label: const Text(
                            "CERRAR SESIÓN",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _editarPerfil() async {
    final nombreController = TextEditingController(text: nombre);
    final emailController = TextEditingController(text: email);
    final formKey = GlobalKey<FormState>();
    final bool tieneFoto = urlImagen != null && urlImagen!.isNotEmpty;

    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color(0xFF132327),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Actualizar Perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Visualizador de foto de perfil
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.cyanAccent,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: const Color(0xFF0D1B1E),
                      backgroundImage: tieneFoto
                          ? MemoryImage(base64Decode(urlImagen!))
                          : null,
                      child: !tieneFoto
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white24,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Botones de acción para la foto
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white10,
                          foregroundColor: Colors.cyanAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await subirImagen();
                        },
                        icon: const Icon(Icons.camera_alt, size: 18),
                        label: Text(tieneFoto ? 'Cambiar' : 'Subir foto'),
                      ),
                      if (tieneFoto) ...[
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await _eliminarImagen();
                          },
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.redAccent,
                          tooltip: 'Eliminar foto',
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Campo Nombre
                  TextFormField(
                    controller: nombreController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Colors.cyanAccent,
                      ),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.cyanAccent),
                      ),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'El nombre es requerido'
                        : null,
                  ),
                  const SizedBox(height: 15),
                  // Campo Correo
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      labelStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.cyanAccent,
                      ),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.cyanAccent),
                      ),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'El correo es requerido'
                        : null,
                  ),
                  const SizedBox(height: 30),
                  // Botones de Guardar / Cancelar
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;

                            final nuevoNombre = nombreController.text.trim();
                            final nuevoEmail = emailController.text.trim();

                            // Si cambió el nombre
                            if (nuevoNombre != nombre) {
                              final ok = await _actualizarNombreApi(
                                widget.userId,
                                nuevoNombre,
                              );
                              if (!ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Error al actualizar nombre'),
                                  ),
                                );
                              }
                            }

                            // Si cambió el email -> iniciar flujo de verificación
                            if (nuevoEmail != email) {
                              final enviado = await _enviarCodigoApi(
                                nuevoEmail,
                              );
                              if (enviado) {
                                Navigator.of(context).pop();
                                await _pedirCodigoYVerificar(nuevoEmail);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No se pudo enviar código'),
                                  ),
                                );
                              }
                            } else {
                              Navigator.of(context).pop();
                              obtenerPerfil();
                            }
                          },
                          child: const Text(
                            'Guardar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
      ),
    );
  }

  Future<bool> _actualizarNombreApi(int id, String nuevoNombre) async {
    try {
      final url = Uri.parse(ApiConfig.url('actualizar_usuario'));
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id, "nombre": nuevoNombre}),
      );
      if (res.statusCode == 200) return true;
    } catch (e) {
      print('Error actualizarNombre: $e');
    }
    return false;
  }

  Future<bool> _enviarCodigoApi(String emailDestino) async {
    try {
      final url = Uri.parse(ApiConfig.url('enviar_codigo'));
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": emailDestino}),
      );
      final data = jsonDecode(res.body);
      return res.statusCode == 200 && data['status'] == 'success';
    } catch (e) {
      print('Error enviarCodigo: $e');
      return false;
    }
  }

  Future<void> _pedirCodigoYVerificar(String nuevoEmail) async {
    final codigoController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF132327),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.mark_email_read_outlined, color: Colors.cyanAccent),
            SizedBox(width: 10),
            Text(
              'Confirmar correo',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Se ha enviado un código al nuevo correo. Ingresa el código para confirmar.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: codigoController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 5,
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '000000',
                hintStyle: const TextStyle(
                  color: Colors.white24,
                  letterSpacing: 5,
                ),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.cyanAccent),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final codigo = codigoController.text.trim();
              if (codigo.isEmpty) return;
              final ok = await _verificarYCambiarEmailApi(
                widget.userId,
                nuevoEmail,
                codigo,
              );
              Navigator.pop(context, ok);
            },
            child: const Text(
              'Confirmar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo actualizado exitosamente')),
      );
      obtenerPerfil();
    } else if (confirmed == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código incorrecto o verificación cancelada'),
        ),
      );
    }
  }

  Future<bool> _verificarYCambiarEmailApi(
    int id,
    String nuevoEmail,
    String codigo,
  ) async {
    try {
      final url = Uri.parse(ApiConfig.url('verificar_y_cambiar_email'));
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "nuevo_email": nuevoEmail,
          "codigo": codigo,
        }),
      );
      final data = jsonDecode(res.body);
      return res.statusCode == 200 && data['status'] == 'success';
    } catch (e) {
      print('Error verificarYCambiarEmail: $e');
      return false;
    }
  }

  Widget _buildAvatar() {
    final tieneFoto = urlImagen != null && urlImagen!.isNotEmpty;

    return GestureDetector(
      onTap: tieneFoto ? _verFotoEnGrande : subirImagen,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.cyanAccent, Color(0xFF017A74)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: const Color(0xFF0D1B1E),
              backgroundImage: tieneFoto
                  ? MemoryImage(base64Decode(urlImagen!))
                  : null,
              child: !tieneFoto
                  ? const Icon(Icons.person, size: 70, color: Colors.white24)
                  : null,
            ),
          ),
          if (!tieneFoto)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.cyanAccent,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0D1B1E), width: 3),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 20,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }

  Widget _cardInfo(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.cyanAccent, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
