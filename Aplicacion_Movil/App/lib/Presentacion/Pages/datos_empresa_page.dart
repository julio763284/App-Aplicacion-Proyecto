import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatosEmpresaPage extends StatefulWidget {
  const DatosEmpresaPage({super.key});

  @override
  State<DatosEmpresaPage> createState() => _DatosEmpresaPageState();
}

class _DatosEmpresaPageState extends State<DatosEmpresaPage> {
  static const Color nexusCyan = Color(0xFF00FBFF);

  final _formKey = GlobalKey<FormState>();
  bool _editando = false;
  bool _guardando = false;

  final _nombreCtrl      = TextEditingController();
  final _nitCtrl         = TextEditingController();
  final _telefonoCtrl    = TextEditingController();
  final _correoCtrl      = TextEditingController();
  final _direccionCtrl   = TextEditingController();
  final _ciudadCtrl      = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreCtrl.text      = prefs.getString('empresa_nombre')      ?? '';
      _nitCtrl.text         = prefs.getString('empresa_nit')         ?? '';
      _telefonoCtrl.text    = prefs.getString('empresa_telefono')    ?? '';
      _correoCtrl.text      = prefs.getString('empresa_correo')      ?? '';
      _direccionCtrl.text   = prefs.getString('empresa_direccion')   ?? '';
      _ciudadCtrl.text      = prefs.getString('empresa_ciudad')      ?? '';
      _descripcionCtrl.text = prefs.getString('empresa_descripcion') ?? '';
    });
  }

  Future<void> _guardarDatos() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('empresa_nombre',      _nombreCtrl.text.trim());
    await prefs.setString('empresa_nit',         _nitCtrl.text.trim());
    await prefs.setString('empresa_telefono',    _telefonoCtrl.text.trim());
    await prefs.setString('empresa_correo',      _correoCtrl.text.trim());
    await prefs.setString('empresa_direccion',   _direccionCtrl.text.trim());
    await prefs.setString('empresa_ciudad',      _ciudadCtrl.text.trim());
    await prefs.setString('empresa_descripcion', _descripcionCtrl.text.trim());

    setState(() {
      _guardando = false;
      _editando  = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: nexusCyan.withOpacity(0.15),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: nexusCyan, size: 18),
              SizedBox(width: 10),
              Text('Datos guardados', style: TextStyle(color: nexusCyan)),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _nitCtrl.dispose();
    _telefonoCtrl.dispose();
    _correoCtrl.dispose();
    _direccionCtrl.dispose();
    _ciudadCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: nexusCyan, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'DATOS DE MI EMPRESA',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: nexusCyan,
          ),
        ),
        actions: [
          if (!_editando)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: nexusCyan, size: 20),
              onPressed: () => setState(() => _editando = true),
              tooltip: 'Editar',
            ),
          if (_editando)
            TextButton(
              onPressed: () => setState(() => _editando = false),
              child: Text('Cancelar', style: TextStyle(color: theme.dividerColor, fontSize: 13)),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // Logo / avatar empresa
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: nexusCyan.withOpacity(0.4), width: 2),
                ),
                child: const Icon(Icons.business_rounded, color: nexusCyan, size: 36),
              ),
            ),
            const SizedBox(height: 28),

            _seccion('INFORMACIÓN GENERAL', theme),
            _campo(
              ctrl: _nombreCtrl,
              label: 'Nombre de la empresa',
              icono: Icons.storefront_outlined,
              theme: theme,
              obligatorio: true,
            ),
            _campo(
              ctrl: _nitCtrl,
              label: 'NIT / RUT',
              icono: Icons.badge_outlined,
              theme: theme,
              tipo: TextInputType.number,
            ),
            _campo(
              ctrl: _descripcionCtrl,
              label: 'Descripción del negocio',
              icono: Icons.notes_outlined,
              theme: theme,
              maxLines: 3,
            ),

            const SizedBox(height: 8),
            _seccion('CONTACTO', theme),
            _campo(
              ctrl: _telefonoCtrl,
              label: 'Teléfono / WhatsApp',
              icono: Icons.phone_outlined,
              theme: theme,
              tipo: TextInputType.phone,
            ),
            _campo(
              ctrl: _correoCtrl,
              label: 'Correo electrónico',
              icono: Icons.email_outlined,
              theme: theme,
              tipo: TextInputType.emailAddress,
            ),

            const SizedBox(height: 8),
            _seccion('UBICACIÓN', theme),
            _campo(
              ctrl: _direccionCtrl,
              label: 'Dirección',
              icono: Icons.location_on_outlined,
              theme: theme,
            ),
            _campo(
              ctrl: _ciudadCtrl,
              label: 'Ciudad',
              icono: Icons.apartment_outlined,
              theme: theme,
            ),

            const SizedBox(height: 32),

            if (_editando)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _guardando ? null : _guardarDatos,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: nexusCyan,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: _guardando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Icon(Icons.save_outlined, size: 18),
                  label: Text(
                    _guardando ? 'GUARDANDO...' : 'GUARDAR CAMBIOS',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _seccion(String titulo, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, top: 4),
      child: Row(
        children: [
          Text(
            titulo,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 10,
              letterSpacing: 2,
              color: nexusCyan.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: nexusCyan.withOpacity(0.15), height: 1)),
        ],
      ),
    );
  }

  Widget _campo({
    required TextEditingController ctrl,
    required String label,
    required IconData icono,
    required ThemeData theme,
    TextInputType tipo = TextInputType.text,
    int maxLines = 1,
    bool obligatorio = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        enabled: _editando,
        keyboardType: tipo,
        maxLines: maxLines,
        style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14),
        validator: obligatorio
            ? (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: _editando ? nexusCyan.withOpacity(0.8) : theme.dividerColor,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            icono,
            color: _editando ? nexusCyan.withOpacity(0.7) : theme.dividerColor,
            size: 18,
          ),
          filled: true,
          fillColor: theme.cardColor.withOpacity(_editando ? 1 : 0.5),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: nexusCyan.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: nexusCyan),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
