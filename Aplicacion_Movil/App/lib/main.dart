import 'package:flutter/material.dart';

void main() {
  runApp(InventaryMobile());
}

class InventaryMobile extends StatelessWidget {
  const InventaryMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 122, 116),
        title: Text(
          "INVENTARY MOBILE",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(30.0),
        padding: EdgeInsets.only(top: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                  width: 150.0 ,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 1, 122, 116),
                    image: DecorationImage(image: AssetImage('assets/iconoGestorProductos.png'))
                  ),
                  ),
                  SizedBox(height: 50.0,),
                  Container(
                  width: 150.0,
                  height: 150.0,
                  color: const Color.fromARGB(255, 1, 122, 116),
                ),
                  ],
                ),
                SizedBox(width: 80.0),
                Column(
                  children: [
                    Container(
                  width: 150.0 ,
                  height: 150.0,
                  color: const Color.fromARGB(255, 1, 122, 116),
                  ),
                SizedBox(height: 50.0,),
                  Container(
                  width: 150.0,
                  height: 150.0,
                  color: const Color.fromARGB(255, 1, 122, 116),
                ),
                  ],                  
                )
              ],
        ),
      ),
    );
  }
}
