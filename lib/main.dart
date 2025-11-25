import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Importar el core de Firebase
import 'package:bugsafe_app/login.dart';
// import 'firebase_options.dart'; // Descomenta si usaste 'flutterfire configure'

void main() async {
  // 2. Convertir el main en asíncrono
  WidgetsFlutterBinding.ensureInitialized(); // 3. Necesario para interactuar con el motor nativo antes de iniciar la UI

  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform, // Recomendado si configuraste Firebase mediante CLI
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Opcional: quita la etiqueta "Debug"
      title: 'BugSafe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Asegura que uses los últimos diseños de Material
      ),
      home:
          const LoginPage(), // Asegúrate que en login.dart la clase se llame LoginPage
    );
  }
}
