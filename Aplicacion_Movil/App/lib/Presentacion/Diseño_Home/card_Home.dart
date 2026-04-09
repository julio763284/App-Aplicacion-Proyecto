import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class CardHome extends StatelessWidget {
  final String text;
  final IconData icon;
  final Widget? page;

  // Color primario de la app
  static const Color primaryColor = Color(0xFF017A74);

  const CardHome({
    super.key,
    required this.text,
    required this.icon,
    this.page,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page!),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Icon(icon, color: Colors.white, size: 32),
          ],
        ),
      ),
    );
  }
}