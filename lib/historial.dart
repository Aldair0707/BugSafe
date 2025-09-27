import 'package:flutter/material.dart';

class Insecto {
  final String nombre;
  final String fecha;

  Insecto({required this.nombre, required this.fecha});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Historial de Insectos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HistorialScreen(),
    );
  }
}

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Insecto> historial = [
      Insecto(nombre: "Hormiga Roja", fecha: "12/12/2025"),
      Insecto(nombre: "Escarabajo", fecha: "11/12/2025"),
      Insecto(nombre: "Mariposa Azul", fecha: "10/12/2025"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: historial.length,
          itemBuilder: (context, index) {
            final insecto = historial[index];
            return HistorialCard(insecto: insecto);
          },
        ),
      ),
    );
  }
}

class HistorialCard extends StatelessWidget {
  final Insecto insecto;

  const HistorialCard({super.key, required this.insecto});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nombre del insecto: ${insecto.nombre}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  hint: const Text("Ver detalles"),
                  items: const [
                    DropdownMenuItem(
                      value: "card",
                      child: Text("Mostrar más info"),
                    ),
                  ],
                  onChanged: (value) {
                    //mas informacion prox
                  },
                ),
              ],
            ),
          ),

          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.delete, size: 30),
                onPressed: () {
                  // funcion de borrar
                },
              ),
              const SizedBox(height: 20),
              Text(insecto.fecha, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
