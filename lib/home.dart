import 'package:flutter/material.dart';
import 'package:bugsafe_app/login.dart';
import 'package:bugsafe_app/profile.dart';

// ----------------- MODELO -----------------
class Insecto {
  final String nombre;
  final String imagenUrl;
  final String descripcion;

  Insecto({
    required this.nombre,
    required this.imagenUrl,
    required this.descripcion,
  });

  factory Insecto.fromJson(Map<String, dynamic> json) {
    return Insecto(
      nombre: json['nombre'] ?? "Insecto",
      imagenUrl: json['imagenUrl'] ?? "",
      descripcion: json['descripcion'] ?? "Sin descripción",
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  Future<List<Insecto>> fetchInsectos() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Insecto(
        nombre: "Insecto X",
        imagenUrl:
            "https://upload.wikimedia.org/wikipedia/commons/3/3e/Moth.jpg",
        descripcion: "Insecto de ejemplo",
      ),
      Insecto(
        nombre: "Insecto Y",
        imagenUrl:
            "https://upload.wikimedia.org/wikipedia/commons/3/3e/Moth.jpg",
        descripcion: "Otro insecto de prueba",
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Buscar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Buscar presionado")));
    } else if (index == 1) {
      // Cámara
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraPage()),
      );
    } else if (index == 2) {
      // Historial
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Historial presionado")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              const Text(
                "BUGSAFE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
              // Logo desde assets
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Image.asset("assets/logo2.jpeg", height: 32, width: 32),
              ),
            ],
          ),
          centerTitle: true,
        ),
      ),

      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Insecto>>(
              future: fetchInsectos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error al cargar insectos"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No hay insectos registrados"),
                  );
                }

                final insectos = snapshot.data!;
                return ListView.builder(
                  itemCount: insectos.length,
                  itemBuilder: (context, index) {
                    final insecto = insectos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Card(
                        color: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Image.network(
                            insecto.imagenUrl,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(insecto.nombre),
                          subtitle: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InfoPage(),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Saber más"),
                                Icon(Icons.arrow_right_alt),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: "Cámara",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historial",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(user: UserModel()),
            ),
          );
        },
        child: const Icon(Icons.person),
      ),
    );
  }
}

// ---------------- CAMERA ----------------
class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cámara")),
      body: const Center(
        child: Text(
          "Aquí irá la funcionalidad de la cámara",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// ---------------- PROFILE ----------------
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),
      body: const Center(
        child: Text(
          "Aquí irá la información del perfil del usuario",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// ---------------- INFO ----------------
class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Más Información")),
      body: const Center(
        child: Text(
          "Aquí puedes mostrar detalles adicionales de la app",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
