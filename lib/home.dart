import 'package:flutter/material.dart';
import 'package:bugsafe_app/login.dart';
import 'package:bugsafe_app/profile.dart';
import 'info_page.dart';
import 'camera_page.dart';
import 'historial.dart';

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(user: UserModel()),
          //builder: (context) => ProfileScreen(),
        ),
      );
    } else if (index == 1) {
      // Cámara
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraPage()),
      );
    } else if (index == 2) {
      // Perfil
      Navigator.push(
        context,
        MaterialPageRoute(
          //builder: (context) => ProfileScreen(user: UserModel()),
          builder: (context) => HistorialScreen(),
        ),
      );
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
                    final screenWidth = MediaQuery.of(context).size.width;

                    // tamaños responsivos
                    final double imageSize =
                        screenWidth * 0.2; // 20% del ancho de pantalla
                    final double fontSize = screenWidth < 400 ? 14 : 18;

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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  insecto.imagenUrl,
                                  width: imageSize,
                                  height: imageSize,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.image_not_supported,
                                        size: 60,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Contenido flexible
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      insecto.nombre,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const InfoPage(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.arrow_right_alt),
                                        label: const Text("Saber más"),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(
                                            screenWidth * 0.25,
                                            30,
                                          ),
                                          textStyle: TextStyle(
                                            fontSize: fontSize * 0.9,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "perfil"),
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
    );
  }
}
