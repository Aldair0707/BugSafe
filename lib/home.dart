import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// --- IMPORTS ---
import 'camera_page.dart';
import 'historial.dart';
import 'info_page.dart';
import 'profile.dart';

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
  int _selectedIndex = 0;

  final Color _bgBlack = const Color(0xFF050505);
  final Color _neonAccent = const Color(0xFF9C27B0);

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraPage()),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeView();
      case 1:
        return Container();
      case 2:
        return const HistorialScreen();
      case 3:
        return ProfileScreen(user: UserModel());
      default:
        return const HomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBlack,
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedItemColor: _neonAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: "Cámara",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "Historial",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          ],
        ),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Color _neonAccent = const Color(0xFF9C27B0);

  Future<List<Insecto>> fetchInsectos() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Insecto(
        nombre: "Mariposa Monarca",
        imagenUrl:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Monarch_Butterfly_Danaus_plexippus_Male_2664px.jpg/640px-Monarch_Butterfly_Danaus_plexippus_Male_2664px.jpg",
        descripcion: "Conocida por su larga migración anual.",
      ),
      Insecto(
        nombre: "Escarabajo Hércules",
        imagenUrl:
            "https://media.istockphoto.com/id/589953406/es/foto/escarabajo-h%C3%A9rcules.jpg?s=612x612&w=0&k=20&c=nXW1fY59mULi5JSrw07tSqCU6zueeXrLLoMl7a7ysko=",
        descripcion: "Uno de los escarabajos más grandes y fuertes.",
      ),
      Insecto(
        nombre: "Abeja Melífera",
        imagenUrl:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Apis_mellifera_Western_honey_bee.jpg/640px-Apis_mellifera_Western_honey_bee.jpg",
        descripcion: "Vital para la polinización de cultivos.",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.8),
              radius: 1.5,
              colors: [Color(0xFF252525), Color(0xFF050505)],
            ),
          ),
        ),

        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "DESCUBRIMIENTOS RECIENTES",
                  style: TextStyle(
                    color: _neonAccent,
                    fontSize: 12,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildInsectList()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "BIENVENIDO A",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "BUGSAFE",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _neonAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: _neonAccent.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black,
              backgroundImage: AssetImage("assets/logo2.jpeg"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Buscar insecto...",
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            prefixIcon: Icon(Icons.search, color: _neonAccent),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsectList() {
    return FutureBuilder<List<Insecto>>(
      future: fetchInsectos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: _neonAccent));
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error al cargar",
              style: TextStyle(color: Colors.white),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Sin datos", style: TextStyle(color: Colors.white)),
          );
        }

        final insectos = snapshot.data!;
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: insectos.length,
          itemBuilder: (context, index) {
            return _buildInsectCard(insectos[index]);
          },
        );
      },
    );
  }

  Widget _buildInsectCard(Insecto insecto) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InfoPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.black,
                    child: Image.network(
                      insecto.imagenUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.bug_report,
                        size: 40,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            insecto.nombre,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            insecto.descripcion,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: _neonAccent,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
