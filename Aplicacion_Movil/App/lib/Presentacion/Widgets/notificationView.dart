import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allNotifications = [];
  List<dynamic> _filteredNotifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      final url = Uri.parse(ApiConfig.url('/notificaciones'));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _allNotifications = data;
            _filteredNotifications = data;
            _isLoading = false;
          });
        }
      } else {
        _handleError();
      }
    } catch (e) {
      _handleError();
    }
  }

  void _handleError() {
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al conectar con el servidor")),
      );
    }
  }

  void _filterNotifications(String query) {
    setState(() {
      _filteredNotifications = _allNotifications
          .where((n) => n['mensaje'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF0D1B1E);
    const accentTeal = Color(0xFF017A74);

    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "NOTIFICACIONES",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: accentTeal.withOpacity(0.05),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterNotifications,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Buscar en el historial...",
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        prefixIcon: const Icon(Icons.search, color: Colors.greenAccent),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: const BorderSide(color: accentTeal),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.greenAccent,
                          strokeWidth: 3,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _fetchNotifications,
                        color: Colors.greenAccent,
                        backgroundColor: const Color(0xFF162A2D),
                        child: _filteredNotifications.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _filteredNotifications.length,
                                itemBuilder: (context, index) {
                                  return _buildNotificationCard(
                                    _filteredNotifications[index]['mensaje'],
                                    _filteredNotifications[index]['fecha'] ?? '',
                                  );
                                },
                              ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView( // Usamos ListView para que el RefreshIndicator funcione
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Icon(Icons.notifications_off_outlined, size: 80, color: Colors.white.withOpacity(0.1)),
        const SizedBox(height: 20),
        Center(
          child: Text(
            "Sin notificaciones",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(String text, String date) {
    final bool isAgotado = text.toUpperCase().contains("AGOTADO");
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162A2D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isAgotado ? Colors.redAccent : const Color(0xFF017A74)).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAgotado ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
              color: isAgotado ? Colors.redAccent : Colors.greenAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 14, 
                    fontWeight: FontWeight.w500,
                    height: 1.4
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3), 
                    fontSize: 11,
                    letterSpacing: 0.5
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