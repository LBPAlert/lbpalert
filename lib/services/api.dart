import 'package:http/http.dart' as http;
import "dart:math";

Future<String> makePostRequest(json) async {
  const url = "http://ec2-18-234-82-111.compute-1.amazonaws.com:80/predict";
  final headers = {"Content-type": "application/json"};

  final response =
      await http.post(Uri.parse(url), headers: headers, body: json);

  if (response.statusCode == 200) {
    var prediction = response.body.replaceAll("[", "");
    prediction = prediction.replaceAll("]", "");

    List<String> predictionList = prediction.split(' ');
    predictionList.remove("");
    predictionList.remove("");

    List<double> predictionListDouble =
        predictionList.map(double.parse).toList();

    var maxPrediction = predictionListDouble.reduce(max);

    final predictedValue =
        predictionListDouble.indexWhere((element) => element == maxPrediction);

    print("Prediction: $predictedValue");

    return predictedValue.toString();
  } else {
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
    throw Exception('Failed to create prediction');
  }
}
