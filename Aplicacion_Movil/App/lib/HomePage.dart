import "package:flutter/material.dart";


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [ 
            Column(
            children: [
              SizedBox(height: 50),
              //Row contiene el titulo y el icono del Home//
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/Logo.png"))
                    ),
                  ),
                  Expanded(child: Center(child: Text("Inventario Movil", style: TextStyle(fontSize: 30,))))
                ],
              ),
              //Row contiene el titulo y el icono del Home//
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50, left: 30, right: 30),
                    padding: EdgeInsets.only(top: 20),
                    height: 900,
                    width: double.infinity,
                    decoration: BoxDecoration(
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //BotonHome es la clase que contiene el diseño de los botones de la vista Home//
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [SizedBox(width: 10) , BotonHome(url : "GestionarProducto.jpg"), SizedBox(width: 10)  , BotonHome(url : "GestionarReportes.jpg")]),
                        SizedBox(height: 20),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [SizedBox(width: 10) , BotonHome(url:  "VisualizarStock.jpg"), SizedBox(width: 10)  , BotonHome(url: "GestionarCliente.jpg")]),
                        SizedBox(height: 20),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [SizedBox(width: 10) , BotonHome(url:  "GestionarProveedor.jpg"), SizedBox(width: 10)  , BotonHome(url : "Alertas.jpg")]),
                        SizedBox(height: 20),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [BotonHome(url: "ControlarFinanzas.jpg")])
                      ],
                    )
                  ),
                ],
              )
            ],
          ),
        ]
      ),
    );
  }
}

class BotonHome extends StatelessWidget {
  final String url;
  const BotonHome({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: (){},  borderRadius: BorderRadius.circular(12),
    child: Ink(
      height: 150,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage(url),
        fit: BoxFit.cover
        ),
      ),
    ),
    );
  }
}
