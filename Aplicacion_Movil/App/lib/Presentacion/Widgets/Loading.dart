import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(double delay) {
    return FadeTransition(
      opacity: Tween(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, delay + 0.4, curve: Curves.easeInOut),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.only(left: 3),
        child: Text(
          ".",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(153, 0, 0, 0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 122, 116),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _controller,
              child: const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  strokeCap: StrokeCap.round, // bordes redondeados pro
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22D3EE)),
                  backgroundColor: Color.fromARGB(96, 14, 12, 12),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Cargando",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                ),
                _dot(0.0),
                _dot(0.2),
                _dot(0.4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
