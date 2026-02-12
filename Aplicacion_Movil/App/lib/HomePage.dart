import 'package:flutter/material.dart';
import 'package:gestor/informes.dart';

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
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.only(top: 40.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "Gestionar Productos",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 1, 122, 116),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(2, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30.0),
                    color: const Color.fromARGB(255, 1, 122, 116),
                    image: DecorationImage(
                      image: AssetImage('assets/iconoGestorProductos.png'),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "Gestionar Productos",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 1, 122, 116),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InformesView(),
                      ),
                    );
                  },
                  child: Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(2, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30.0),
                      color: const Color.fromARGB(255, 1, 122, 116),
                      image: const DecorationImage(
                        image: AssetImage('assets/reporte19.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 80.0),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "Visualizar Stock",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 1, 122, 116),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(2, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30.0),
                    color: const Color.fromARGB(255, 1, 122, 116),
                    image: DecorationImage(
                      image: AssetImage('assets/VisualizarStock.png'),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "Revisar Alertas",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 1, 122, 116),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(2, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30.0),
                    color: const Color.fromARGB(255, 1, 122, 116),
                    image: DecorationImage(
                      image: AssetImage('assets/avisoredi.png'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
