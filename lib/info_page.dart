import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Más Información")),
      body: const Center(
        child: Text(
          "Aquí puedes mostrar detalles adicionales de la app",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
