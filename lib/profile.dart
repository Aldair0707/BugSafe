import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bugsafe_app/authService.dart';
import 'package:bugsafe_app/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  //PALETA
  final Color _bgBlack = const Color(0xFF050505);
  final Color _neonAccent = const Color(0xFF9C27B0);
  final Color _surfaceColor = const Color(0xFF1A1A1A);

  // Función para editar y actualizar
  void _editField(String fieldKey, String currentValue, String dialogTitle) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          title: Text(
            "Editar $dialogTitle",
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            cursorColor: _neonAccent,
            decoration: InputDecoration(
              hintText: "Ingresa nuevo valor",
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _neonAccent.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _neonAccent),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (currentUser != null && controller.text.trim().isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(currentUser!.uid)
                      .update({fieldKey: controller.text.trim()});
                }
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _neonAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("No user logged in")));
    }

    return Scaffold(
      backgroundColor: _bgBlack,
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.8),
                radius: 1.2,
                colors: [const Color(0xFF252525), _bgBlack],
              ),
            ),
          ),

          SafeArea(
            //StreamBuilder escucha cambios en el documento del usuario en tiempo real
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: _neonAccent),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Error al cargar perfil",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text(
                      "Perfil no encontrado",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;

                final String name = userData['name'] ?? "Usuario";
                final String username = userData['username'] ?? "sin_usuario";
                final String email =
                    userData['email'] ?? currentUser!.email ?? "Sin correo";
                final String phone = userData['phoneNumber'] ?? "Sin teléfono";
                final String country = userData['country'] ?? "Sin país";

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      //HEADER
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 45),
                            const Text(
                              "MI PERFIL",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: _neonAccent.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 15,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _neonAccent,
                                      width: 2,
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.black,
                                    backgroundImage: AssetImage(
                                      "assets/logo2.jpeg",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      //FOTO DE PERFI
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _neonAccent.withValues(alpha: 0.3),
                                  blurRadius: 40,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          const CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.black,
                            backgroundImage: AssetImage("assets/logo2.jpeg"),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _neonAccent,
                                shape: BoxShape.circle,
                                border: Border.all(color: _bgBlack, width: 3),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // NOMBRE Y USUARIO (Editables)
                      GestureDetector(
                        onTap: () => _editField("name", name, "Nombre"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.edit,
                              color: Colors.white.withValues(alpha: 0.3),
                              size: 16,
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () =>
                            _editField("username", username, "Usuario"),
                        child: Text(
                          "@$username",
                          style: TextStyle(
                            color: _neonAccent,
                            fontSize: 14,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Column(
                                children: [
                                  _buildGlassTile(
                                    Icons.email_outlined,
                                    "Email",
                                    email,
                                    null,
                                  ),
                                  _buildDivider(),
                                  _buildGlassTile(
                                    Icons.phone_outlined,
                                    "Teléfono",
                                    phone,
                                    () => _editField(
                                      "phoneNumber",
                                      phone,
                                      "Teléfono",
                                    ),
                                  ),
                                  _buildDivider(),
                                  _buildGlassTile(
                                    Icons.location_on_outlined,
                                    "País",
                                    country,
                                    () =>
                                        _editField("country", country, "País"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      TextButton.icon(
                        onPressed: () async {
                          final authService = AuthService();
                          await authService.logout();

                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        icon: Icon(
                          Icons.logout,
                          color: Colors.redAccent.withValues(alpha: 0.8),
                        ),
                        label: Text(
                          "Cerrar Sesión",
                          style: TextStyle(
                            color: Colors.redAccent.withValues(alpha: 0.8),
                            fontSize: 16,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassTile(
    IconData icon,
    String title,
    String value,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: _neonAccent, size: 20),
      ),
      title: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: onTap != null
          ? IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white.withValues(alpha: 0.2),
                size: 18,
              ),
              onPressed: onTap,
            )
          : const SizedBox(width: 48),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.white.withValues(alpha: 0.1),
      indent: 20,
      endIndent: 20,
    );
  }
}
