import 'package:flutter/material.dart';

class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cámara")),
      body: Center(
        child: Text(
          "Aquí irá la funcionalidad de la cámara",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
