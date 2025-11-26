import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/prediction_service.dart';
import '../services/database_service.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  String? _resultado;
  bool _loading = false;

  final PredictionService _predictor = PredictionService();
  final DatabaseService _dbService = DatabaseService();

  String clase(int index) {
    const clases = ["Hormiga", "Abeja", "Escarabajo", "Mosca", "Avispa"];
    if (index < 0 || index >= clases.length) return "Desconocido";
    return clases[index];
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
      );

      if (picked == null) return;

      setState(() {
        _image = File(picked.path);
        _resultado = null;
      });

      await _predictAndSave();
    } catch (e) {
      print("Error al seleccionar imagen: $e");
    }
  }

  Future<void> _predictAndSave() async {
    if (_image == null) return;

    setState(() => _loading = true);

    try {
      int index = await _predictor.predict(_image!);
      String insectName = clase(index);

      await _dbService.saveDetection(
        insectResult: insectName,
        confidence: 0.95,
      );

      setState(() {
        _resultado = "Insecto detectado: $insectName";
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.history, color: Colors.white),
                SizedBox(width: 10),
                Text("Registro guardado exitosamente"),
              ],
            ),
            backgroundColor: _neonAccent.withValues(alpha: 0.8),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      print("Error en proceso: $e");
      setState(() {
        _resultado = "Error al analizar";
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al guardar el registro."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => _loading = false);
  }

  void _clearSelection() {
    setState(() {
      _image = null;
      _resultado = null;
    });
  }

  final Color _bgBlack = const Color(0xFF050505);
  final Color _neonAccent = const Color(0xFF9C27B0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBlack,
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [const Color(0xFF252525), Colors.black],
              ),
            ),
          ),

          Positioned.fill(
            child: _image != null
                ? Image.file(_image!, fit: BoxFit.cover)
                : _buildScannerOverlay(),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.9),
                    ],
                    stops: const [0.0, 0.2, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGlassIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  Text(
                    "BUG DETECTOR AI",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 3.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  _image != null
                      ? _buildGlassIconButton(
                          icon: Icons.refresh,
                          onTap: _clearSelection,
                        )
                      : const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          if (_loading)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: _neonAccent),
                    const SizedBox(height: 20),
                    const Text(
                      "Analizando...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_resultado != null && !_loading)
            Positioned(
              bottom: 180,
              left: 20,
              right: 20,
              child: _buildResultCard(),
            ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                _buildCorner(Alignment.topLeft),
                _buildCorner(Alignment.topRight),
                _buildCorner(Alignment.bottomLeft),
                _buildCorner(Alignment.bottomRight),
                Center(
                  child: Icon(
                    Icons.bug_report_outlined,
                    size: 60,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Enfoca el insecto aquí",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              letterSpacing: 1.2,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y == -1
                ? BorderSide(color: _neonAccent, width: 3)
                : BorderSide.none,
            bottom: alignment.y == 1
                ? BorderSide(color: _neonAccent, width: 3)
                : BorderSide.none,
            left: alignment.x == -1
                ? BorderSide(color: _neonAccent, width: 3)
                : BorderSide.none,
            right: alignment.x == 1
                ? BorderSide(color: _neonAccent, width: 3)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _neonAccent, width: 1),
            boxShadow: [
              BoxShadow(
                color: _neonAccent.withValues(alpha: 0.2),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: _neonAccent, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "RESULTADO",
                      style: TextStyle(
                        color: _neonAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      _resultado ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTextButton(
            Icons.photo_library,
            "Galería",
            () => _getImage(ImageSource.gallery),
          ),

          GestureDetector(
            onTap: () => _getImage(ImageSource.camera),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _neonAccent,
                  boxShadow: [
                    BoxShadow(
                      color: _neonAccent.withValues(alpha: 0.4),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
