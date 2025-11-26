import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class PredictionService {
  final url = Uri.parse(
    "https://mejorado-l7s4.onrender.com/v1/models/reconocimiento-mejorado:predict",
  );

  final headers = {"Content-Type": "application/json;charset=UTF-8"};

  Future<List<List<List<double>>>> processImage(File file) async {
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) return [];

    img.Image resized = img.copyResize(image, width: 300, height: 300);

    List<List<List<double>>> result = List.generate(
      300,
      (i) => List.generate(300, (j) {
        int pixel = resized.getPixel(j, i);

        double r = img.getRed(pixel) / 255.0;
        double g = img.getGreen(pixel) / 255.0;
        double b = img.getBlue(pixel) / 255.0;

        return [r, g, b];
      }),
    );

    return result;
  }

  Future<int> predict(File image) async {
    final processed = await processImage(image);

    final body = jsonEncode({
      "instances": [processed],
    });

    final res = await http.post(url, headers: headers, body: body);

    if (res.statusCode != 200) {
      print(res.body);
      throw Exception("Error en la petición al modelo");
    }

    final jsonPrediction = jsonDecode(res.body);
    final pred = jsonPrediction['predictions'][0] as List;

    int maxIndex = pred.indexOf(pred.reduce((a, b) => a > b ? a : b));
    return maxIndex;
  }
}
