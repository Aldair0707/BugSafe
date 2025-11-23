import 'package:bugsafe_app/authService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bugsafe_app/models/usuario.dart';
import 'authService.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  bool loading = true;

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
          title: Text("Editar $fieldName"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: fieldName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _updateField(fieldName, controller.text);
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  void _updateField(String fieldName, String newValue) async {
    if (user == null) return;

    setState(() {
      switch (fieldName) {
        case "Email":
          user!.email = newValue;
          break;
        case "Phone":
          user!.phone = newValue;
          break;
        case "Country":
          user!.country = newValue;
          break;
        case "Username":
          user!.username = newValue;
          break;
      }
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .update(user!.toMap());

    debugPrint("Campo $fieldName actualizado: $newValue");
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final u = user!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("BUGSAFE", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo2.jpeg', width: 35, height: 35),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 60, color: Colors.black),
            ),
            const SizedBox(height: 15),
            Text(
              u.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(u.username, style: const TextStyle(color: Colors.grey)),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                  onPressed: () => _editField("Username", u.username),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(u.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      onPressed: () => _editField("Email", u.email),
                    ),
                  ),
                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(u.phone),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      onPressed: () => _editField("Phone", u.phone),
                    ),
                  ),
                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(u.country),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      onPressed: () => _editField("Country", u.country),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            TextButton.icon(
              onPressed: () async {
                // 1. Cerrar sesión en Firebase
                await AuthService().logout();

                // 2. Navegar al Login y borrar el historial de navegación
                // Asegúrate de cambiar 'LoginScreen()' por el nombre real de tu widget de login.
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) =>
                        false, // Esto elimina todas las rutas anteriores (Home, Profile, etc.)
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text("Log out", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
