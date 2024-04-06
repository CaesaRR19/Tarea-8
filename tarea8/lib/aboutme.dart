import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: const Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                    radius: 75,
                    backgroundImage:
                        NetworkImage('https://i.imgur.com/7bw7xUC.jpg')),
                SizedBox(height: 20),
                Text('César Omar Ramos Nolasco',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                SizedBox(height: 20),
                Text('2022-0022',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                SizedBox(height: 10),
                Text(
                  'La democracia se fortalece con la participación activa y consciente de cada ciudadano en las elecciones, ejerciendo el derecho al voto como un acto supremo de servicio cívico.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )));
  }
}
