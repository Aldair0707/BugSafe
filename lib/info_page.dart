import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Más Información"), centerTitle: true),
      body: const InsectInfoCard(),
    );
  }
}

class InsectInfoCard extends StatelessWidget {
  const InsectInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Insect X',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nombre cientifio:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(''),
                  const SizedBox(height: 8),
                  const Text(
                    'Descripcion larga:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(''),
                  const SizedBox(height: 8),
                  const Text(
                    'Habitad:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(''),
                  const SizedBox(height: 8),
                  const Text(
                    'Alimentacion:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(''),
                  const SizedBox(height: 8),
                  const Text(
                    'Nivel de riesgo:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(''),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
