import 'package:flutter/material.dart';
import 'package:bugsafe_app/home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El email no puede estar vacío";
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return "Ingrese un email válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La contraseña no puede estar vacía";
                  }
                  if (value.length < 6) {
                    return "Debe tener al menos 6 caracteres";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Confirmar contraseña
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Confirmar contraseña"),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "Las contraseñas no coinciden";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Botón de registro
              ElevatedButton(
                child: const Text("Crear cuenta"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí iría la lógica de registrar en tu backend
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                },
              ),

              TextButton(
                child: const Text("Ya tengo cuenta"),
                onPressed: () {
                  Navigator.pop(context); // Regresa al login
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
