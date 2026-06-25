import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class EscanerBarrasPage extends StatefulWidget {
  const EscanerBarrasPage({super.key});

  @override
  State<EscanerBarrasPage> createState() => _EscanerBarrasPageState();
}

class _EscanerBarrasPageState extends State<EscanerBarrasPage>
    with SingleTickerProviderStateMixin {
  static const Color nexusCyan = Color(0xFF00FBFF);

  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  List<Map<String, String>> _historial = [];
  String? _ultimoCodigo;
  bool _escaneando = true;
  late AnimationController _lineaAnim;

  @override
  void initState() {
    super.initState();
    _lineaAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _lineaAnim.dispose();
    super.dispose();
  }

  void _onDetectar(BarcodeCapture capture) {
    if (!_escaneando) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final codigo = barcode.rawValue!;
    final tipo   = barcode.format.name;

    HapticFeedback.mediumImpact();

    setState(() {
      _ultimoCodigo = codigo;
      _escaneando   = false;
      _historial.insert(0, {
        'codigo': codigo,
        'tipo': tipo,
        'hora': TimeOfDay.now().format(context),
      });
      if (_historial.length > 20) _historial = _historial.sublist(0, 20);
    });

    _mostrarResultado(codigo, tipo);
  }

  void _mostrarResultado(String codigo, String tipo) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: nexusCyan.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.check_circle_outline, color: nexusCyan, size: 40),
            const SizedBox(height: 12),
            Text(
              'CÓDIGO DETECTADO',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 11,
                letterSpacing: 2,
                color: nexusCyan.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: nexusCyan.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: nexusCyan.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    codigo,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tipo.toUpperCase(),
                    style: TextStyle(
                      color: nexusCyan.withOpacity(0.5),
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: codigo));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Copiado al portapapeles'),
                          backgroundColor: nexusCyan.withOpacity(0.15),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: nexusCyan.withOpacity(0.4)),
                      foregroundColor: nexusCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.copy_outlined, size: 16),
                    label: const Text('Copiar', style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() => _escaneando = true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: nexusCyan,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.qr_code_scanner, size: 16),
                    label: const Text(
                      'Escanear otro',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ).whenComplete(() => setState(() => _escaneando = true));
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
          'ESCÁNER DE BARRAS',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: nexusCyan,
          ),
        ),
        actions: [
          // Flash
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (ctx, state, _) {
              final flashOn = state.torchState == TorchState.on;
              return IconButton(
                icon: Icon(
                  flashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                  color: flashOn ? nexusCyan : theme.dividerColor,
                  size: 20,
                ),
                onPressed: () => _controller.toggleTorch(),
                tooltip: 'Linterna',
              );
            },
          ),
          // Cámara flip
          IconButton(
            icon: const Icon(Icons.flip_camera_ios_outlined, color: nexusCyan, size: 20),
            onPressed: () => _controller.switchCamera(),
            tooltip: 'Cambiar cámara',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Visor de cámara ────────────────────────────────────────────────
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetectar,
                ),

                // Overlay oscuro
                Container(color: Colors.black.withOpacity(0.45)),

                // Marco de escaneo
                Center(
                  child: Container(
                    width: 240,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: nexusCyan, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Esquinas decorativas
                        ..._esquinas(),
                        // Línea de escaneo animada
                        AnimatedBuilder(
                          animation: _lineaAnim,
                          builder: (_, __) => Positioned(
                            top: _lineaAnim.value * 140 + 8,
                            left: 8,
                            right: 8,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    nexusCyan.withOpacity(0),
                                    nexusCyan,
                                    nexusCyan.withOpacity(0),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(1),
                                boxShadow: [
                                  BoxShadow(
                                    color: nexusCyan.withOpacity(0.6),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Texto guía
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Text(
                    _escaneando
                        ? 'Apunta al código de barras o QR'
                        : 'Procesando...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ),

                // Último código flotante
                if (_ultimoCodigo != null)
                  Positioned(
                    top: 16,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: nexusCyan.withOpacity(0.3)),
                      ),
                      child: Text(
                        _ultimoCodigo!,
                        style: const TextStyle(
                          color: nexusCyan,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Historial ─────────────────────────────────────────────────────
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HISTORIAL',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: nexusCyan.withOpacity(0.7),
                        ),
                      ),
                      if (_historial.isNotEmpty)
                        TextButton(
                          onPressed: () => setState(() => _historial.clear()),
                          child: Text(
                            'Limpiar',
                            style: TextStyle(
                              color: theme.dividerColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: _historial.isEmpty
                      ? Center(
                          child: Text(
                            'Aún no has escaneado nada',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              color: theme.dividerColor,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _historial.length,
                          itemBuilder: (ctx, i) {
                            final item = _historial[i];
                            return ListTile(
                              dense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tileColor: i == 0
                                  ? nexusCyan.withOpacity(0.05)
                                  : Colors.transparent,
                              leading: Icon(
                                Icons.qr_code_2_outlined,
                                color: i == 0 ? nexusCyan : theme.dividerColor,
                                size: 20,
                              ),
                              title: Text(
                                item['codigo']!,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 13,
                                  color: i == 0 ? nexusCyan : null,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${item['tipo']} · ${item['hora']}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 10,
                                  color: theme.dividerColor,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.copy_outlined, size: 15),
                                color: theme.dividerColor,
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: item['codigo']!),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _esquinas() {
    const size = 18.0;
    const width = 2.5;
    const color = nexusCyan;

    Widget corner({required bool top, required bool left}) {
      return Positioned(
        top: top ? 0 : null,
        bottom: top ? null : 0,
        left: left ? 0 : null,
        right: left ? null : 0,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CornerPainter(
              topLeft: top && left,
              topRight: top && !left,
              bottomLeft: !top && left,
              bottomRight: !top && !left,
              color: color,
              strokeWidth: width,
            ),
          ),
        ),
      );
    }

    return [
      corner(top: true,  left: true),
      corner(top: true,  left: false),
      corner(top: false, left: true),
      corner(top: false, left: false),
    ];
  }
}

class _CornerPainter extends CustomPainter {
  final bool topLeft, topRight, bottomLeft, bottomRight;
  final Color color;
  final double strokeWidth;

  const _CornerPainter({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    if (topLeft) {
      canvas.drawLine(Offset(0, h), Offset(0, 0), paint);
      canvas.drawLine(Offset(0, 0), Offset(w, 0), paint);
    } else if (topRight) {
      canvas.drawLine(Offset(0, 0), Offset(w, 0), paint);
      canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
    } else if (bottomLeft) {
      canvas.drawLine(Offset(0, 0), Offset(0, h), paint);
      canvas.drawLine(Offset(0, h), Offset(w, h), paint);
    } else if (bottomRight) {
      canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
      canvas.drawLine(Offset(w, h), Offset(0, h), paint);
    }
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}
