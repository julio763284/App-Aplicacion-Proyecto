import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? page;

  const MenuButton({
    super.key,
    required this.icon,
    required this.text,
    this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: ElevatedButton.icon(
        onPressed: () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page!),
            );
          }
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF017A74),
          elevation: 0,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}