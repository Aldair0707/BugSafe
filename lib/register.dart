import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bugsafe_app/authService.dart';
//import 'package:bugsafe_app/home.dart';
import 'package:bugsafe_app/login.dart';

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

  // Colores del tema
  final Color _bgBlack = const Color(0xFF050505);
  final Color _neonAccent = const Color(0xFF9C27B0);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
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

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                      const SizedBox(height: 10),

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
                                  color: _neonAccent.withValues(alpha: 0.6),
                                  blurRadius: 50,
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

                      const SizedBox(height: 30),

                      const Text(
                        "CREAR CUENTA",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        "Únete a la comunidad BugSafe",
                        style: TextStyle(
                          color: _neonAccent,
                          fontSize: 14,
                          letterSpacing: 1.0,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // INPUTS
                      _buildModernTextField(
                        controller: _nameController,
                        label: "Nombre completo",
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "El nombre es requerido";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      _buildModernTextField(
                        controller: _usernameController,
                        label: "Nombre de usuario",
                        icon: Icons.alternate_email,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Usuario requerido";
                          }
                          if (value.trim().length < 4) {
                            return "Mínimo 4 caracteres";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      _buildModernTextField(
                        controller: _emailController,
                        label: "Correo electrónico",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Correo requerido";
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return "Correo inválido";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      _buildModernTextField(
                        controller: _passwordController,
                        label: "Contraseña",
                        icon: Icons.lock_outline,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Contraseña requerida";
                          }
                          if (value.trim().length < 6) {
                            return "Mínimo 6 caracteres";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 40),

                      // BOTÓN DE REGISTRO CON LÓGICA
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _neonAccent,
                            foregroundColor: Colors.white,
                            elevation: 10,
                            shadowColor: _neonAccent.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _handleRegister,
                          child: const Text(
                            "REGISTRARSE",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Redirección al Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿Ya tienes cuenta?",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Iniciar sesión",
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
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Center(child: CircularProgressIndicator(color: _neonAccent)),
      );

      try {
        final authService = AuthService();

        await authService.register(
          name: _nameController.text.trim(),
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted) Navigator.pop(context);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) Navigator.pop(context);

        String errorMessage = "Error al crear la cuenta";

        if (e.code == 'email-already-in-use') {
          errorMessage = "Este correo ya está en uso.";
        } else if (e.code == 'weak-password') {
          errorMessage = "La contraseña es muy débil.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "El correo no es válido.";
        } else if (e.code == 'network-request-failed') {
          errorMessage = "Error de conexión.";
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red.withValues(alpha: 0.8),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        // Otros errores
        if (mounted) Navigator.pop(context);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "Ocurrió un error inesperado",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red.withValues(alpha: 0.8),
            ),
          );
        }
      }
    }
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
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
        prefixIcon: Icon(icon, color: _neonAccent.withValues(alpha: 0.7)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _neonAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.redAccent.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
