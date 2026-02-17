import 'package:flutter/material.dart';

class VisualizarStock extends StatelessWidget {
  const VisualizarStock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Visualizar Stock", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 1, 122, 116),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(color:Color.fromARGB(255, 1, 122, 116)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {print("Selecciono Tarjetas");}, child: Text("Tarjetas", style: TextStyle(color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 1, 122, 116)),),
                SizedBox(width: 50.0),
                ElevatedButton(onPressed: () {print("Selecciono Tablas");}, child: Text("Tablas", style: TextStyle(color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 1, 122, 116)),),
                SizedBox(width: 50.0),
                ElevatedButton(onPressed: () {print("Selecciono Grafico");}, child: Text("Grafico", style: TextStyle(color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 1, 122, 116)),),
              ],
            ),
          ),
          SizedBox(height: 70.0),
          Container(
            height: 350.0,
            width: 300.0,
            decoration: BoxDecoration(color: Color.fromARGB(174, 1, 122, 116) , borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              children: [
                Image.asset("assets/gif/Stock_Vacio.gif", width: 250, height: 250),
                Text("No Hay Productos en Inventario...", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 18.0),)
              ],
            ),
          )

        ],
      ),
    );
  }
}
