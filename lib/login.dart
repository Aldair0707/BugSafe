import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final Color _bgBlack = const Color(0xFF050505);
  final Color _neonAccent = const Color(0xFF9C27B0);

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
      backgroundColor: _bgBlack,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.8),
                radius: 1.5,
                colors: [const Color(0xFF252525), _bgBlack],
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _neonAccent.withOpacity(0.6),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          backgroundImage: AssetImage("assets/logo2.jpeg"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "BUGSAFE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                      ),
                    ),

                    Text(
                      "AI INSECT DETECTOR",
                      style: TextStyle(
                        color: _neonAccent,
                        fontSize: 12,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 50),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "INICIAR SESIÓN",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // EMAIL
                    _buildModernTextField(
                      controller: _emailController,
                      label: "Correo electrónico",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo requerido";
                        }
                        if (!value.contains("@")) {
                          return "Correo inválido";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // PASSWORD
                    _buildModernTextField(
                      controller: _passwordController,
                      label: "Contraseña",
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Campo requerido";
                        if (value.length < 6) return "Mínimo 6 caracteres";
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "¿Olvidaste tu contraseña?",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // BOTÓN LOGIN NORMAL
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _neonAccent,
                          foregroundColor: Colors.white,
                          elevation: 10,
                          shadowColor: _neonAccent.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await _authService.login(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );

                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomePage(),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error: $e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          "ACCEDER",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // BOTÓN GOOGLE
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _neonAccent),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          try {
                            final userCredential =
                                await _authService.loginWithGoogle();

                            if (userCredential != null) {
                              final user = userCredential.user!;
                              final userDoc =
                                  FirebaseFirestore.instance.collection("users").doc(user.uid);

                              if (!(await userDoc.get()).exists) {
                                await userDoc.set({
                                  "name": user.displayName ?? "",
                                  "username": user.email!.split("@")[0],
                                  "email": user.email,
                                  "country": "",
                                  "phoneNumber": "",
                                  "createdAt": DateTime.now(),
                                });
                              }

                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomePage(),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Google Auth Error: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text("Continuar con Google"),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "¿No tienes cuenta?",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Regístrate",
                            style: TextStyle(
                              color: _neonAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      cursorColor: _neonAccent,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: _neonAccent),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _neonAccent, width: 1.5),
        ),
      ),
    );
  }
}
