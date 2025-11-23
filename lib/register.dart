import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Asegúrate de que estas rutas sean correctas en tu proyecto
import 'package:bugsafe_app/home.dart';
import 'package:bugsafe_app/login.dart';
import 'authService.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Es buena práctica liberar los controladores
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- Logo y Encabezado ---
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/logo.jpeg",
                          height: 120,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.bug_report, size: 80);
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "BugSafe",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- Título ---
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Campos del Formulario ---

                  // Nombre Completo
                  _buildTextField(
                    controller: _nameController,
                    label: "Nombre completo",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "El nombre no puede estar vacío";
                      }
                      return null;
                    },
                  ),

                  // Email
                  _buildTextField(
                    controller: _emailController,
                    label: "Correo electrónico",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "El correo no puede estar vacío";
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) {
                        return "Ingrese un correo válido";
                      }
                      return null;
                    },
                  ),

                  // Username
                  _buildTextField(
                    controller: _usernameController,
                    label: "Nombre de usuario",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "El nombre de usuario no puede estar vacío";
                      }
                      if (value.length < 4) {
                        return "El usuario debe tener al menos 4 caracteres";
                      }
                      return null;
                    },
                  ),

                  // Password
                  _buildTextField(
                    controller: _passwordController,
                    label: "Contraseña",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "La contraseña no puede estar vacía";
                      }
                      if (value.length < 6) {
                        return "La contraseña debe tener al menos 6 caracteres";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  // --- Botón de Registro ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        // Validar el formulario antes de enviar
                        if (_formKey.currentState!.validate()) {
                          final auth = AuthService();
                          try {
                            await auth.register(
                              name: _nameController.text,
                              username: _usernameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              );
                            }
                          } catch (e) {
                            print("Error registrando: $e");
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                          }
                        }
                      },
                      child: const Text(
                        "Crear cuenta",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // --- Botón Volver al Login ---
                  TextButton(
                    child: const Text("¿Ya tienes cuenta? Iniciar sesión"),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Método helper para construir los campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
