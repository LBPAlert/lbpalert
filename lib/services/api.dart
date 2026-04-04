import 'package:http/http.dart' as http;

Future<String> makePostRequest(json) async {
  const url = "http://ec2-54-196-167-23.compute-1.amazonaws.com:80/predict";
  final headers = {"Content-type": "application/json"};
  final int predictedValue;

  final response =
      await http.post(Uri.parse(url), headers: headers, body: json);

  if (response.statusCode == 200) {
    var prediction = response.body.replaceAll("[", "");
    prediction = prediction.replaceAll("]", "");

    var doublePrediction = double.parse(prediction);
    if (doublePrediction < 0) {
      predictedValue = 0;
    } else if (doublePrediction > 10) {
      predictedValue = 10;
    } else {
      predictedValue = doublePrediction.round();
    }
    print("Prediction: $predictedValue");

    return predictedValue.toString();
  } else {
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
    throw Exception('Failed to create prediction');
  }
}
