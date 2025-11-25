import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class UserModel {
  String fullName;
  String username;
  String email;
  String phone;
  String country;

  UserModel({
    this.fullName = "Full Name",
    this.username = "bughunter_2025",
    this.email = "usuario@bugsafe.com",
    this.phone = "+52 55 1234 5678",
    this.country = "México",
  });
}

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- PALETA ---
  final Color _bgBlack = const Color(0xFF050505);
  final Color _neonAccent = const Color(0xFF9C27B0);
  final Color _surfaceColor = const Color(0xFF1A1A1A);

  void _editField(String fieldName, String currentValue) {
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
            "Editar $fieldName",
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            cursorColor: _neonAccent,
            decoration: InputDecoration(
              labelText: fieldName,
              labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
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
              onPressed: () {
                _updateField(fieldName, controller.text);
                Navigator.pop(context);
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

  void _updateField(String fieldName, String newValue) {
    setState(() {
      switch (fieldName) {
        case "Email":
          widget.user.email = newValue;
          break;
        case "Phone":
          widget.user.phone = newValue;
          break;
        case "Country":
          widget.user.country = newValue;
          break;
        case "Username":
          widget.user.username = newValue;
          break;
        case "Name":
          widget.user.fullName = newValue;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      backgroundColor: _bgBlack,
      body: Stack(
        children: [
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
                                    color: _neonAccent.withValues(alpha: 0.4),
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

                  GestureDetector(
                    onTap: () => _editField("Name", user.fullName),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.fullName,
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
                    onTap: () => _editField("Username", user.username),
                    child: Text(
                      "@${user.username}",
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
                                user.email,
                                () => _editField("Email", user.email),
                              ),
                              _buildDivider(),
                              _buildGlassTile(
                                Icons.phone_outlined,
                                "Phone",
                                user.phone,
                                () => _editField("Phone", user.phone),
                              ),
                              _buildDivider(),
                              _buildGlassTile(
                                Icons.location_on_outlined,
                                "Country",
                                user.country,
                                () => _editField("Country", user.country),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
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
    VoidCallback onTap,
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
      trailing: IconButton(
        icon: Icon(
          Icons.edit,
          color: Colors.white.withValues(alpha: 0.2),
          size: 18,
        ),
        onPressed: onTap,
      ),
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
