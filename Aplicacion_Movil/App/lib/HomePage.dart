import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';

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
      //Menu desplegable DRAWER//
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
             icon: Icon(Icons.warehouse, color: Colors.white),
             label: Text("Visualizar Stock", style: TextStyle(color: Colors.white),),
             style: ElevatedButton.styleFrom(backgroundColor:const Color.fromARGB(255, 1, 122, 116)),
             ),
            SizedBox(height: 40.0,),
             ElevatedButton.icon(onPressed: (){},
             icon: Icon(Icons.person, color: Colors.white),
             label: Text("Gestionar Cliente", style: TextStyle(color: Colors.white),),
             style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 1, 122, 116)),
             ),
            SizedBox(height: 40.0,),
              ElevatedButton.icon(onPressed: (){},
             icon: Icon(Icons.local_shipping, color: Colors.white),
             label: Text("Gestionar Proveedores", style: TextStyle(color: Colors.white),),
             style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 1, 122, 116)),
             ),
              SizedBox(height: 40.0,),
              ElevatedButton.icon(onPressed: (){},
             icon: Icon(Icons.warning, color: Colors.white),
             label: Text("Revisar Alertas", style: TextStyle(color: Colors.white),),
             style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 1, 122, 116)),
             ),
              SizedBox(height: 40.0,),
              ElevatedButton.icon(onPressed: (){},
             icon: Icon(Icons.monetization_on, color: Colors.white),
             label: Text("Controlar Finanzas", style: TextStyle(color: Colors.white),),
             style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 1, 122, 116)),
             ),
              SizedBox(height: 40.0,),
              ElevatedButton.icon(onPressed: (){},
             icon: Icon(Icons.storefront, color: Colors.white),
             label: Text("Gestionar Inventario", style: TextStyle(color: Colors.white),),
             style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 1, 122, 116)),
             ),
              SizedBox(height: 40.0,),
              ElevatedButton.icon(onPressed: (){},
             icon: Icon(Icons.settings, color: Colors.white),
             label: Text("Configuracion", style: TextStyle(color: Colors.white),),
             style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 1, 122, 116)),
             )
          ],
      )
      ),
      //Menu desplegable DRAWER//
      body: ListView(
          children: [
            Column(
                children: [
                  SizedBox(height: 100.0,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Container(padding: EdgeInsets.all(10.0), child: Column(children: [Text("Gestionar Productos", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)), IconButton(onPressed: (){print("Gestionar Productos");}, icon: Icon(Icons.inventory, color: Colors.white, size: 30.0,)) ],), decoration: BoxDecoration(color: const Color.fromARGB(255, 1, 122, 116), borderRadius: BorderRadius.circular(15.0))), Container(padding: EdgeInsets.all(10.0),child: Column(children: [Text("Gestionar Reportes", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)), IconButton(onPressed: (){print("Gestionar Reportes");}, icon: Icon(Icons.file_copy, color: Colors.white, size: 30.0)) ],), decoration: BoxDecoration(color: const Color.fromARGB(255, 1, 122, 116), borderRadius: BorderRadius.circular(15.0))),Container(padding: EdgeInsets.all(10.0) ,child: Column(children: [Text("Visualizar Stock", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)), IconButton(onPressed: (){print("Visualizar Stock");}, icon: Icon(Icons.inventory_rounded, color: Colors.white, size: 30.0,)) ],), decoration: BoxDecoration(color: const Color.fromARGB(255, 1, 122, 116), borderRadius: BorderRadius.circular(15.0)))]),
                  SizedBox(height: 50.0,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Container(padding: EdgeInsets.all(10.0), child: Column(children: [Text("Gestionar Cliente", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)), IconButton(onPressed: (){print("Gestionar Cliente");}, icon: Icon(Icons.person, color: Colors.white))],), decoration: BoxDecoration(color: const Color.fromARGB(255, 1, 122, 116), borderRadius: BorderRadius.circular(15.0))), Container(padding: EdgeInsets.all(10.0),child: Column(children: [Text("Gestionar Proveedores", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)), IconButton(onPressed: (){print("Gestionar Proveedores");}, icon: Icon(Icons.local_shipping, color: Colors.white)) ],), decoration : BoxDecoration(color : const Color.fromARGB(255, 1, 122, 116), borderRadius : BorderRadius.circular(15.0))),Container(padding: EdgeInsets.all(10.0),child: Column(children: [Text("Revisar Alertas", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)), IconButton(onPressed: (){print("Revisar Alertas");}, icon: Icon(Icons.warning, color: Colors.white))],), decoration: BoxDecoration(color: const Color.fromARGB(255, 1, 122, 116), borderRadius: BorderRadius.circular(15.0)))]),
                  SizedBox(height: 50.0,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Container(padding: EdgeInsets.all(10.0), child: Column(children: [Text("Controlar Finanzas", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)), IconButton(onPressed: (){print("Presiono Controlar Finanzas");}, icon: Icon(Icons.monetization_on, color: Colors.white)) ],), decoration: BoxDecoration(color: const Color.fromARGB(255, 1, 122, 116), borderRadius: BorderRadius.circular(15.0))), Container(padding: EdgeInsets.all(10.0),child: Column(children: [Text("Gestionar Inventario", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)), IconButton(onPressed: (){print("Presiono Gestionar Inventario");}, icon: Icon(Icons.storefront, color: Colors.white)) ],), decoration: BoxDecoration(color: const Color.fromARGB(255, 1, 122, 116), borderRadius: BorderRadius.circular(15.0))),Container(padding: EdgeInsets.all(10.0),child: Column(children: [Text("Configuracion", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)), IconButton(onPressed: (){print("Presiono Configuracion");}, icon: Icon(Icons.settings , color: Colors.white)) ],), decoration: BoxDecoration(color: const Color.fromARGB(255, 1, 122, 116), borderRadius: BorderRadius.circular(15.0)))]),
                ],
            )
          ],
        ),
    );
  }
}
