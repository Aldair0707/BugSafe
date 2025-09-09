import 'package:flutter/material.dart';
import 'package:bugsafe_app/home.dart';

// ---------------- REGISTRO ----------------
class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Crear cuenta"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            TextButton(
              child: Text("Ya tengo cuenta"),
              onPressed: () {
                Navigator.pop(context); // Regresa al login
              },
            ),
          ],
        ),
      ),
    );
  }
}
