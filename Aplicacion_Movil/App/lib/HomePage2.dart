import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Pages/informes.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 122, 116),
        title: Text(
          "Mobile Inventary",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      drawer: Drawer(
        backgroundColor:  const Color.fromARGB(131, 1, 122, 116),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 20.0,),
            Text("Mobile Inventary", textAlign: TextAlign.center ,style: TextStyle(color: Colors.white, fontSize: 25.0)),
            SizedBox(height: 40.0,),
            ElevatedButton.icon(onPressed: (){},
             icon: Icon(Icons.inventory, color: Colors.white),
             label: Text("Gestionar Productos", style: TextStyle(color: Colors.white),),
             style: ElevatedButton.styleFrom(backgroundColor:  const Color.fromARGB(255, 1, 122, 116)),
             ),
            SizedBox(height: 40.0,),
            ElevatedButton.icon(onPressed: (){},
             icon: Icon(Icons.file_copy, color: Colors.white),
             label: Text("Gestionar Reportes", style: TextStyle(color: Colors.white),),
             style: ElevatedButton.styleFrom(backgroundColor:  const Color.fromARGB(255, 1, 122, 116)),
             ),
            SizedBox(height: 40.0,),
             ElevatedButton.icon(onPressed: (){},
             icon: Icon(Icons.add_alert_sharp, color: Colors.white),
             label: Text("Revisar Alertas", style: TextStyle(color: Colors.white),),
             style: ElevatedButton.styleFrom(backgroundColor:const Color.fromARGB(255, 1, 122, 116)),
             ),
            SizedBox(height: 40.0,),
             ElevatedButton.icon(onPressed: (){},
             icon: Icon(Icons.inventory_rounded, color: Colors.white),
             label: Text("Visualizar Stock", style: TextStyle(color: Colors.white),),
             style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 1, 122, 116)),
             ),
          ],
      )),
    );
  }
}
