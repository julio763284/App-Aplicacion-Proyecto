import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/core/config.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Diseño/appbar.dart';

class GestionarChats extends StatefulWidget {
  const GestionarChats({super.key});

  @override
  State<GestionarChats> createState() => _GestionarChatsState();
}

class _GestionarChatsState extends State<GestionarChats> {
  List<dynamic> chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarChats();
  }

  Future<void> cargarChats() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.url('/soporte/chats-abiertos')),
      );

      if (response.statusCode == 200) {
        setState(() {
          chats = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      drawer: const CustomNexusDrawer(),
      appBar: CustomAppBar(
        conteoNotificaciones: 0,
        onActualizarNotificaciones: () {},
      ),
      body: RefreshIndicator(
        onRefresh: cargarChats,
        color: Colors.greenAccent,
        backgroundColor: const Color(0xFF162A2D),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.greenAccent),
              )
            : chats.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 200),
                      Center(
                        child: Text(
                          "No hay chats abiertos",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF162A2D),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.greenAccent,
                            child: Text(
                              chat['nombre'] != null
                                  ? chat['nombre'][0].toUpperCase()
                                  : '?',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),

                          title: Text(
                            chat['nombre'] ?? 'Sin nombre',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                chat['ultimo_mensaje'] ??
                                    'Sin mensajes aún',
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                chat['correo'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                chat['total_mensajes']?.toString() ?? '0',
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.chat_bubble,
                                color: Colors.greenAccent,
                              ),
                            ],
                          ),

                          onTap: () {
                            // AQUÍ ABRIRÁS EL CHAT
                            // Navigator.push(...)
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}