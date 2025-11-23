import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Asegúrate de que estas rutas coincidan con la estructura de tu proyecto
import 'package:bugsafe_app/home.dart';
import 'package:bugsafe_app/register.dart';
import 'authService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
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
                  // --- LOGO Y MARCA ---
                  Center(
                    child: Column(
                      children: [
                        Image.asset("assets/logo.jpeg", height: 120),
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

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: _emailController,
                    label: "Email address",
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

                  _buildTextField(
                    controller: _passwordController,
                    label: "Password",
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
                        if (_formKey.currentState!.validate()) {
                          try {
                            await _authService.login(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            // Login exitoso -> Home
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            }
                          } catch (e) {
                            print("Error login: $e");
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error: ${e.toString()}"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: const [
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("O", style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(
                        Icons.g_mobiledata,
                        size: 35,
                        color: Colors.red,
                      ),
                      label: const Text(
                        "Continuar con Google",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final userCredential = await _authService
                              .loginWithGoogle();

                          if (userCredential != null &&
                              userCredential.user != null) {
                            final user = userCredential.user!;

                            // 2. Referencia a Firestore
                            final userDocRef = FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid);
                            final docSnapshot = await userDocRef.get();

                            if (!docSnapshot.exists) {
                              // Generar username del email
                              String generatedUsername = user.email!.split(
                                '@',
                              )[0];

                              await userDocRef.set({
                                "name": user.displayName ?? "",
                                "username": generatedUsername,
                                "email": user.email,
                                "country": "",
                                "phoneNumber": "",
                                "createdAt": DateTime.now(),
                              });
                            }

                            // 4. Login exitoso -> Home
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          print("Error Google: $e");
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error Google: ${e.toString()}"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextButton(
                    child: const Text("¿No tienes cuenta? Registrarse"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 5),

                  TextButton(
                    child: const Text("¿Olvidaste tu contraseña?"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
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

  // Método auxiliar para los inputs
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
