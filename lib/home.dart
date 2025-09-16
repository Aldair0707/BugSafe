import 'package:flutter/material.dart';
import 'package:bugsafe_app/login.dart';

// ---------------- HOME ----------------
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón Cerrar Sesión
            ElevatedButton(
              child: Text("Cerrar Sesión"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),

            const SizedBox(height: 20),

            // Botón Cámara
            ElevatedButton(
              child: Text("Cámara"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraPage()),
                );
              },
            ),

            const SizedBox(height: 20),

            // Botón Perfil
            ElevatedButton(
              child: Text("Perfil"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),

            const SizedBox(height: 20),

            // Botón Más información
            ElevatedButton(
              child: Text("Más Información"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InfoPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- CAMERA ----------------
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

// ---------------- PROFILE ----------------
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Perfil")),
      body: Center(
        child: Text(
          "Aquí irá la información del perfil del usuario",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// ---------------- INFO ----------------
class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Más Información")),
      body: Center(
        child: Text(
          "Aquí puedes mostrar detalles adicionales de la app",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
