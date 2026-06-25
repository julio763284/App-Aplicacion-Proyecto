import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Dise%C3%B1o/appbar.dart';
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
  List<dynamic> _allNotifications      = [];
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
      final response =
          await http.get(Uri.parse(ApiConfig.url('/notificaciones')));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _allNotifications      = data;
            _filteredNotifications = data;
            _isLoading             = false;
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
          .where((n) => n['mensaje']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final teal  = theme.colorScheme.primary;
    final cyan  = theme.colorScheme.secondary;

    return Scaffold(
      drawer: const CustomNexusDrawer(),
      appBar: CustomAppBar(
        conteoNotificaciones: 0,
        onActualizarNotificaciones: () {},
      ),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: teal.withOpacity(0.05),
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
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: "Buscar en el historial...",
                        hintStyle: theme.textTheme.bodyMedium,
                        prefixIcon:
                            Icon(Icons.search, color: Colors.greenAccent),
                        filled: true,
                        fillColor: theme.cardColor.withOpacity(0.5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(
                              color: theme.dividerColor.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: teal),
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
                        backgroundColor: theme.cardColor,
                        child: _filteredNotifications.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                itemCount: _filteredNotifications.length,
                                itemBuilder: (context, index) {
                                  return _buildNotificationCard(
                                    _filteredNotifications[index]['mensaje'],
                                    _filteredNotifications[index]['fecha'] ??
                                        '',
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
    final theme = Theme.of(context);
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Icon(Icons.notifications_off_outlined,
            size: 80, color: theme.dividerColor),
        const SizedBox(height: 20),
        Center(
          child: Text("Sin notificaciones",
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(String text, String date) {
    final theme      = Theme.of(context);
    final teal       = theme.colorScheme.primary;
    final isAgotado  = text.toUpperCase().contains("AGOTADO");
    final iconColor  = isAgotado ? Colors.redAccent : Colors.greenAccent;
    final bgColor    = isAgotado ? Colors.redAccent : teal;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: theme.dividerColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAgotado
                  ? Icons.warning_amber_rounded
                  : Icons.inventory_2_outlined,
              color: iconColor,
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
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    letterSpacing: 0.5,
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