import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bugsafe_app/models/usuario.dart';
import 'package:bugsafe_app/authService.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- FIREBASE USER DATA ---
  UserModel? user;
  bool loading = true;

  // --- PALETA VISUAL ---
  final Color _bgBlack = const Color(0xFF050505);
  final Color _neonAccent = const Color(0xFF9C27B0);
  final Color _surfaceColor = const Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final data = await AuthService().getUserData(widget.uid);

    if (data != null) {
      setState(() {
        user = UserModel.fromMap(data);
        loading = false;
      });
    }
  }

  void _editField(String fieldName, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          title: Text("Editar $fieldName", style: const TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            cursorColor: _neonAccent,
            decoration: InputDecoration(
              labelText: fieldName,
              labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _neonAccent),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar", style: TextStyle(color: Colors.white.withOpacity(0.5))),
            ),
            ElevatedButton(
              onPressed: () {
                _updateField(fieldName, controller.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _neonAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text("Guardar"),
            )
          ],
        );
      },
    );
  }

  void _updateField(String fieldName, String newValue) async {
    if (user == null) return;

    setState(() {
      switch (fieldName) {
        case "Name":
          user!.fullName = newValue;
          break;
        case "Username":
          user!.username = newValue;
          break;
        case "Email":
          user!.email = newValue;
          break;
        case "Phone":
          user!.phone = newValue;
          break;
        case "Country":
          user!.country = newValue;
          break;
      }
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .update(user!.toMap());
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final u = user!;

    return Scaffold(
      backgroundColor: _bgBlack,
      body: Stack(
        children: [
          // --- FONDO GRADIENTE ---
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // --- HEADER ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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

                        // LOGO ESQUINA
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
                                    color: _neonAccent.withOpacity(0.4),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: _neonAccent, width: 2),
                              ),
                              child: const CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.black,
                                backgroundImage: AssetImage("assets/logo2.jpeg"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --- AVATAR PRINCIPAL ---
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
                              color: _neonAccent.withOpacity(0.3),
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
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- NOMBRE ---
                  GestureDetector(
                    onTap: () => _editField("Name", u.fullName),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          u.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.edit, size: 16, color: Colors.white54),
                      ],
                    ),
                  ),

                  // --- USERNAME ---
                  GestureDetector(
                    onTap: () => _editField("Username", u.username),
                    child: Text(
                      "@${u.username}",
                      style: TextStyle(
                        color: _neonAccent,
                        fontSize: 14,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- TARJETA GLASS ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Column(
                            children: [
                              _buildGlassTile(Icons.email_outlined, "Email", u.email, () {
                                _editField("Email", u.email);
                              }),
                              _buildDivider(),

                              _buildGlassTile(Icons.phone_outlined, "Phone", u.phone, () {
                                _editField("Phone", u.phone);
                              }),
                              _buildDivider(),

                              _buildGlassTile(Icons.location_on_outlined, "Country", u.country, () {
                                _editField("Country", u.country);
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- LOGOUT ---
                  TextButton.icon(
                    onPressed: () async {
                      await AuthService().logout();

                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      }
                    },
                    icon: Icon(Icons.logout, color: Colors.redAccent.withOpacity(0.8)),
                    label: Text(
                      "Cerrar Sesión",
                      style: TextStyle(
                        color: Colors.redAccent.withOpacity(0.8),
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPONENTES UI ---
  Widget _buildGlassTile(IconData icon, String title, String value, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.black26,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: _neonAccent, size: 20),
      ),
      title: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit, size: 18, color: Colors.white.withOpacity(0.3)),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.white.withOpacity(0.1),
      indent: 20,
      endIndent: 20,
    );
  }
}
