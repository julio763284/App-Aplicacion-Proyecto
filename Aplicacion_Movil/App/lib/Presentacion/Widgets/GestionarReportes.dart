import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/core/config.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Diseño/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Lista de chats abiertos ──────────────────────────────────────────────────

class GestionarChats extends StatefulWidget {
  const GestionarChats({super.key});

  @override
  State<GestionarChats> createState() => _GestionarChatsState();
}

class _GestionarChatsState extends State<GestionarChats> {
  List<dynamic> chats    = [];
  bool _isLoading        = true;

  @override
  void initState() {
    super.initState();
    cargarChats();
  }

  Future<void> cargarChats() async {
    setState(() => _isLoading = true);
    try {
      final response =
          await http.get(Uri.parse(ApiConfig.url('/soporte/chats-abiertos')));
      if (response.statusCode == 200) {
        setState(() {
          chats      = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;

    return Scaffold(
      drawer: const CustomNexusDrawer(),
      appBar: CustomAppBar(
        conteoNotificaciones: 0,
        onActualizarNotificaciones: () {},
      ),
      body: RefreshIndicator(
        onRefresh: cargarChats,
        color: cyan,
        backgroundColor: theme.cardColor,
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: cyan))
            : chats.isEmpty
                ? ListView(
                    children: [
                      const SizedBox(height: 200),
                      Center(
                        child: Text(
                          "No hay chats abiertos",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return _ChatCard(
                        chat: chat,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatDetallePage(
                                usuarioId: chat['usuario_id'],
                                nombreCliente: chat['nombre'] ?? 'Cliente',
                                correoCliente: chat['correo'] ?? '',
                              ),
                            ),
                          );
                          cargarChats(); // refrescar al volver
                        },
                      );
                    },
                  ),
      ),
    );
  }
}

class _ChatCard extends StatelessWidget {
  final Map<String, dynamic> chat;
  final VoidCallback onTap;

  const _ChatCard({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cyan   = theme.colorScheme.secondary;
    final nombre = chat['nombre'] ?? 'Sin nombre';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.greenAccent.withOpacity(0.2),
          child: Text(
            nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
            style: const TextStyle(
                color: Colors.greenAccent, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(nombre,
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(chat['ultimo_mensaje'] ?? 'Sin mensajes',
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(chat['correo'] ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              chat['total_mensajes']?.toString() ?? '0',
              style: TextStyle(
                  color: Colors.greenAccent, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.chat_bubble_outline,
                color: Colors.greenAccent, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Pantalla de chat individual ─────────────────────────────────────────────

class ChatDetallePage extends StatefulWidget {
  final int usuarioId;
  final String nombreCliente;
  final String correoCliente;

  const ChatDetallePage({
    super.key,
    required this.usuarioId,
    required this.nombreCliente,
    required this.correoCliente,
  });

  @override
  State<ChatDetallePage> createState() => _ChatDetallePageState();
}

class _ChatDetallePageState extends State<ChatDetallePage> {
  List<dynamic> _mensajes    = [];
  bool _cargando             = true;
  bool _enviando             = false;
  bool _resuelto             = false;
  final _msgCtrl             = TextEditingController();
  final _scrollCtrl          = ScrollController();
  Timer? _pollingTimer;

  String _adminNombre = 'Admin';
  String _adminCorreo = '';

  @override
  void initState() {
    super.initState();
    _cargarDatosAdmin();
    _cargarMensajes();
    // Polling cada 5 segundos para mensajes nuevos
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _cargarMensajes(silencioso: true),
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarDatosAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      final u = jsonDecode(userData);
      setState(() {
        _adminNombre = u['nombre'] ?? 'Admin';
        _adminCorreo = u['correo'] ?? '';
      });
    }
  }

  Future<void> _cargarMensajes({bool silencioso = false}) async {
    if (!silencioso) setState(() => _cargando = true);
    try {
      final res = await http.get(
        Uri.parse(ApiConfig.url('/soporte/mensajes/${widget.usuarioId}')),
      );
      if (res.statusCode == 200) {
        final nuevos = json.decode(res.body) as List;
        final yaResuelto = nuevos.isNotEmpty &&
            nuevos.every((m) => m['estado'] == 'RESUELTO');
        setState(() {
          _mensajes  = nuevos;
          _resuelto  = yaResuelto;
          _cargando  = false;
        });
        _scrollAlFinal();
      }
    } catch (_) {
      setState(() => _cargando = false);
    }
  }

  void _scrollAlFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _enviarMensaje() async {
    final texto = _msgCtrl.text.trim();
    if (texto.isEmpty || _enviando) return;

    setState(() => _enviando = true);
    _msgCtrl.clear();

    try {
      final res = await http.post(
        Uri.parse(ApiConfig.url('/soporte/responder')),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario_id": widget.usuarioId,
          "mensaje":    texto,
          "nombre":     _adminNombre,
          "correo":     _adminCorreo,
          "asunto":     "Respuesta de soporte",
        }),
      );
      if (res.statusCode == 200) {
        await _cargarMensajes(silencioso: true);
      }
    } catch (_) {}

    setState(() => _enviando = false);
  }

  Future<void> _resolverChat() async {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('¿Marcar como resuelto?',
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        content: Text(
          'Esto cerrará el chat con ${widget.nombreCliente}.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: theme.textTheme.bodyMedium),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: cyan,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Resolver', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final res = await http.put(
      Uri.parse(ApiConfig.url('/soporte/resolver/${widget.usuarioId}')),
    );
    if (res.statusCode == 200) {
      setState(() => _resuelto = true);
      await _cargarMensajes(silencioso: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    final teal  = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: cyan, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.nombreCliente,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              widget.correoCliente,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
            ),
          ],
        ),
        actions: [
          if (!_resuelto)
            IconButton(
              icon: const Icon(Icons.check_circle_outline,
                  color: Colors.greenAccent),
              tooltip: 'Marcar como resuelto',
              onPressed: _resolverChat,
            ),
          if (_resuelto)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.greenAccent.withOpacity(0.4)),
                  ),
                  child: const Text('RESUELTO',
                      style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                ),
              ),
            ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: theme.dividerColor),
            onPressed: () => _cargarMensajes(),
          ),
        ],
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator(color: cyan))
          : Column(
              children: [
                // ── Mensajes ────────────────────────────────────────────────
                Expanded(
                  child: _mensajes.isEmpty
                      ? Center(
                          child: Text('Sin mensajes aún',
                              style: theme.textTheme.bodyMedium),
                        )
                      : ListView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          itemCount: _mensajes.length,
                          itemBuilder: (_, i) =>
                              _BurbujaMensaje(mensaje: _mensajes[i]),
                        ),
                ),

                // ── Barra de resolución si ya está resuelto ──────────────
                if (_resuelto)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.greenAccent.withOpacity(0.08),
                    child: const Text(
                      'Este chat está marcado como resuelto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                // ── Input ────────────────────────────────────────────────
                if (!_resuelto)
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      border: Border(
                          top: BorderSide(
                              color: theme.dividerColor.withOpacity(0.2))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  color: theme.dividerColor.withOpacity(0.3)),
                            ),
                            child: TextField(
                              controller: _msgCtrl,
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(fontSize: 14),
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                hintText: 'Escribe una respuesta...',
                                hintStyle: theme.textTheme.bodyMedium,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _enviando ? null : _enviarMensaje,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: _enviando
                                  ? cyan.withOpacity(0.4)
                                  : cyan,
                              shape: BoxShape.circle,
                            ),
                            child: _enviando
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: CircularProgressIndicator(
                                        color: Colors.black, strokeWidth: 2),
                                  )
                                : const Icon(Icons.send_rounded,
                                    color: Colors.black, size: 20),
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

// ─── Burbuja de mensaje ───────────────────────────────────────────────────────

class _BurbujaMensaje extends StatelessWidget {
  final Map<String, dynamic> mensaje;

  const _BurbujaMensaje({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    final theme     = Theme.of(context);
    final cyan      = theme.colorScheme.secondary;
    final esAdmin   = mensaje['remitente'] == 'admin';
    final texto     = mensaje['mensaje'] ?? '';
    final hora      = mensaje['fecha_creacion'] ?? '';
    final nombre    = mensaje['nombre'] ?? (esAdmin ? 'Admin' : 'Cliente');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            esAdmin ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!esAdmin) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.greenAccent.withOpacity(0.2),
              child: Text(
                nombre.isNotEmpty ? nombre[0].toUpperCase() : 'C',
                style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: esAdmin
                    ? cyan.withOpacity(0.15)
                    : theme.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(esAdmin ? 16 : 4),
                  bottomRight: Radius.circular(esAdmin ? 4 : 16),
                ),
                border: Border.all(
                  color: esAdmin
                      ? cyan.withOpacity(0.3)
                      : theme.dividerColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: esAdmin
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!esAdmin)
                    Text(nombre,
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  if (!esAdmin) const SizedBox(height: 4),
                  Text(texto,
                      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(hora,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10)),
                ],
              ),
            ),
          ),
          if (esAdmin) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: cyan.withOpacity(0.2),
              child: Icon(Icons.admin_panel_settings_outlined,
                  color: cyan, size: 14),
            ),
          ],
        ],
      ),
    );
  }
}