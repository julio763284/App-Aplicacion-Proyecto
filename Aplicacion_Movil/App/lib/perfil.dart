import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/core/config.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestor/Presentacion/Pages/LoginHome.dart';

class PerfilPage extends StatefulWidget {
  final int userId;
  const PerfilPage({super.key, required this.userId});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String nombre    = "";
  String email     = "";
  String? urlImagen;
  bool loading     = true;

  @override
  void initState() {
    super.initState();
    obtenerPerfil();
  }

  Future<void> obtenerPerfil() async {
    try {
      final res = await http.get(Uri.parse(ApiConfig.url('perfil?id=${widget.userId}')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          nombre    = data['nombre'] ?? "";
          email     = data['correo'] ?? "";
          urlImagen = data['imagen'];
          loading   = false;
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
    final bytes = await File(image.path).readAsBytes();
    final base64Image = base64Encode(bytes);
    try {
      final res = await http.post(
        Uri.parse(ApiConfig.url('subir_imagen')),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": widget.userId, "imagen": base64Image}),
      );
      if (res.statusCode == 200) obtenerPerfil();
    } catch (e) {
      debugPrint("Error: $e");
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
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.logout, color: Colors.redAccent),
            const SizedBox(width: 10),
            Text("Cerrar sesión",
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text("¿Estás seguro de que deseas cerrar sesión?",
            style: theme.textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar", style: theme.textTheme.bodyMedium),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      final res = await http.post(
        Uri.parse(ApiConfig.url('eliminar_imagen')),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": widget.userId}),
      );
      if (res.statusCode == 200) {
        setState(() => urlImagen = null);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto de perfil eliminada exitosamente')),
          );
        }
      }
    } catch (e) {
      debugPrint("Error al eliminar imagen: $e");
    }
  }

  void _verFotoEnGrande() {
    if (urlImagen == null || urlImagen!.isEmpty) return;
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: theme.scaffoldBackgroundColor,
          child: Stack(
            children: [
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
                        BoxShadow(color: cyan.withOpacity(0.15), blurRadius: 30, spreadRadius: 5),
                      ],
                      border: Border.all(color: cyan.withOpacity(0.3), width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.memory(base64Decode(urlImagen!), fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: IconButton(
                      icon: Icon(Icons.close_rounded, color: cyan, size: 28),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.cardColor.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: cyan.withOpacity(0.2)),
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
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;

    if (loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: cyan)),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("PERFIL",
            style: theme.textTheme.bodyLarge?.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            color: theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) { if (value == 'editar') _editarPerfil(); },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'editar',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, color: cyan, size: 20),
                    const SizedBox(width: 10),
                    Text('Actualizar perfil', style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildAvatar(),
                      const SizedBox(height: 20),
                      Text(nombre,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 5),
                      Text(email, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16)),
                      const SizedBox(height: 40),
                      _cardInfo(Icons.email_outlined,  "Correo electrónico", email),
                      _cardInfo(Icons.person_outline,  "Nombre de usuario",  nombre),
                      const Spacer(),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withOpacity(0.9),
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                        ),
                        onPressed: _confirmLogout,
                        label: const Text("CERRAR SESIÓN",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            )),
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
    );
  }

  Future<void> _editarPerfil() async {
    final theme            = Theme.of(context);
    final cyan             = theme.colorScheme.secondary;
    final nombreController = TextEditingController(text: nombre);
    final emailController  = TextEditingController(text: email);
    final formKey          = GlobalKey<FormState>();
    final bool tieneFoto   = urlImagen != null && urlImagen!.isNotEmpty;

    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 10)),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Actualizar Perfil',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(color: cyan, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: theme.scaffoldBackgroundColor,
                      backgroundImage: tieneFoto ? MemoryImage(base64Decode(urlImagen!)) : null,
                      child: !tieneFoto
                          ? Icon(Icons.person, size: 50, color: theme.dividerColor)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.dividerColor.withOpacity(0.1),
                          foregroundColor: cyan,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  _themedField(nombreController, 'Nombre', Icons.person_outline, theme, cyan,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'El nombre es requerido' : null),
                  const SizedBox(height: 15),
                  _themedField(emailController, 'Correo electrónico', Icons.email_outlined, theme, cyan,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'El correo es requerido' : null),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Cancelar', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cyan,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;
                            final nuevoNombre = nombreController.text.trim();
                            final nuevoEmail  = emailController.text.trim();
                            if (nuevoNombre != nombre) {
                              final ok = await _actualizarNombreApi(widget.userId, nuevoNombre);
                              if (!ok && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Error al actualizar nombre')),
                                );
                              }
                            }
                            if (nuevoEmail != email) {
                              final enviado = await _enviarCodigoApi(nuevoEmail);
                              if (enviado) {
                                Navigator.of(context).pop();
                                await _pedirCodigoYVerificar(nuevoEmail);
                              } else if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('No se pudo enviar código')),
                                );
                              }
                            } else {
                              Navigator.of(context).pop();
                              obtenerPerfil();
                            }
                          },
                          child: const Text('Guardar',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  Widget _themedField(
    TextEditingController ctrl,
    String label,
    IconData icon,
    ThemeData theme,
    Color cyan, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      style: theme.textTheme.bodyLarge,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodyMedium,
        prefixIcon: Icon(icon, color: cyan),
        filled: true,
        fillColor: theme.scaffoldBackgroundColor.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: cyan),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Future<bool> _actualizarNombreApi(int id, String nuevoNombre) async {
    try {
      final res = await http.post(
        Uri.parse(ApiConfig.url('actualizar_usuario')),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id, "nombre": nuevoNombre}),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _enviarCodigoApi(String emailDestino) async {
    try {
      final res = await http.post(
        Uri.parse(ApiConfig.url('enviar_codigo')),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": emailDestino}),
      );
      final data = jsonDecode(res.body);
      return res.statusCode == 200 && data['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<void> _pedirCodigoYVerificar(String nuevoEmail) async {
    final theme           = Theme.of(context);
    final cyan            = theme.colorScheme.secondary;
    final codigoController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.mark_email_read_outlined, color: cyan),
            const SizedBox(width: 10),
            Text('Confirmar correo', style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Se ha enviado un código al nuevo correo. Ingresa el código para confirmar.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: codigoController,
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 20, letterSpacing: 5),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '000000',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(letterSpacing: 5),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor.withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: cyan),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar', style: theme.textTheme.bodyMedium),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: cyan,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final codigo = codigoController.text.trim();
              if (codigo.isEmpty) return;
              final ok = await _verificarYCambiarEmailApi(widget.userId, nuevoEmail, codigo);
              Navigator.pop(context, ok);
            },
            child: const Text('Confirmar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (confirmed == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo actualizado exitosamente')),
      );
      obtenerPerfil();
    } else if (confirmed == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código incorrecto o verificación cancelada')),
      );
    }
  }

  Future<bool> _verificarYCambiarEmailApi(int id, String nuevoEmail, String codigo) async {
    try {
      final res = await http.post(
        Uri.parse(ApiConfig.url('verificar_y_cambiar_email')),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id, "nuevo_email": nuevoEmail, "codigo": codigo}),
      );
      final data = jsonDecode(res.body);
      return res.statusCode == 200 && data['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Widget _buildAvatar() {
    final theme    = Theme.of(context);
    final cyan     = theme.colorScheme.secondary;
    final teal     = theme.colorScheme.primary;
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
              gradient: LinearGradient(
                colors: [cyan, teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(color: cyan.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
              ],
            ),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: theme.scaffoldBackgroundColor,
              backgroundImage: tieneFoto ? MemoryImage(base64Decode(urlImagen!)) : null,
              child: !tieneFoto
                  ? Icon(Icons.person, size: 70, color: theme.dividerColor)
                  : null,
            ),
          ),
          if (!tieneFoto)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cyan,
                shape: BoxShape.circle,
                border: Border.all(color: theme.scaffoldBackgroundColor, width: 3),
              ),
              child: const Icon(Icons.camera_alt, size: 20, color: Colors.black),
            ),
        ],
      ),
    );
  }

  Widget _cardInfo(IconData icon, String title, String value) {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cyan.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: cyan, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontSize: 17, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}