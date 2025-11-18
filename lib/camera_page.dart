import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'services/prediction_service.dart';

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

  Future<void> _getImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);

    if (picked == null) return;

    setState(() {
      _image = File(picked.path);
      _resultado = null;
    });

    await _predict();
  }

  Future<void> _predict() async {
    if (_image == null) return;

    setState(() => _loading = true);

    try {
      int resultado = await _predictor.predict(_image!);

      setState(() {
        _resultado = "Predicción del modelo: $resultado";
      });
    } catch (e) {
      setState(() {
        _resultado = "Error en predicción";
      });
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detectar Insecto"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_image != null)
            Image.file(
              _image!,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            )
          else
            Image.asset(
              "assets/take_photo.gif",
              height: 250,
            ),

          const SizedBox(height: 20),

          if (_loading)
            const CircularProgressIndicator(),

          if (_resultado != null && !_loading)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                _resultado!,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => _getImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text("Cámara"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _getImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text("Galería"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
