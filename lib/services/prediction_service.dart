import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class PredictionService {
  final url = Uri.parse(
      "https://flower-kt94.onrender.com/v1/models/flower:predict");
  final headers = {"Content-Type": "application/json;charset=UTF-8"};

  Future<List<List<List<double>>>> processImage(File file) async {
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) return [];

    img.Image resized = img.copyResize(image, width: 64, height: 64);

    return List.generate(
      64,
      (i) => List.generate(
        64,
        (j) {
          int pixel = resized.getPixel(j, i);
          return [
            ((pixel >> 16) & 0xFF) / 255.0,
            ((pixel >> 8) & 0xFF) / 255.0,
            (pixel & 0xFF) / 255.0,
          ];
        },
      ),
    );
  }

  Future<int> predict(File image) async {
    final processedImage = await processImage(image);

    final body = jsonEncode({"instances": [processedImage]});

    final res = await http.post(url, headers: headers, body: body);

    if (res.statusCode != 200) {
      throw Exception("Error en la petición al modelo");
    }

    final jsonPrediction = jsonDecode(res.body);
    final pred = jsonPrediction['predictions'][0] as List;

    /// obtiene el índice con mayor probabilidad
    int maxIndex = pred.indexOf(pred.reduce((a, b) => a > b ? a : b));

    return maxIndex;
  }
}
