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
              SizedBox(height: 70),
              //Row contiene el titulo y el icono del Home//
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Colors.red)
                    ),
                  ),
                  Expanded(child: Center(child: Text("Inventario Movil", style: TextStyle(fontSize: 30,))))
                ],
              ),
              //Row contiene el titulo y el icono del Home//
              Container(
                margin: EdgeInsets.only(top: 80, left: 30, right: 30),
                padding: EdgeInsets.only(top: 20),
                height: 900,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: Colors.black)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //BotonHome es la clase que contiene el diseño de los botones de la vista Home//
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [SizedBox(width: 10) , BotonHome(), SizedBox(width: 10)  , BotonHome()]),
                    SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [SizedBox(width: 10) , BotonHome(), SizedBox(width: 10)  , BotonHome()]),
                    SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [SizedBox(width: 10) , BotonHome(), SizedBox(width: 10)  , BotonHome()]),
                    SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [SizedBox(width: 10) , BotonHome(), SizedBox(width: 10)  , BotonHome()]),
                    SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [BotonHome()])
                  ],
                )
              )
            ],
          ),
        ]
      ),
    );
  }
}

class BotonHome extends StatelessWidget {
  const BotonHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: (){},  borderRadius: BorderRadius.circular(12),
    child: Ink(
      height: 150,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue
      ),
    ),
    );
  }
}