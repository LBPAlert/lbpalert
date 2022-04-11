import 'package:http/http.dart' as http;

Future<String> makePostRequest() async {
  const url = "http://ec2-18-234-82-111.compute-1.amazonaws.com:80/predict";

  final headers = {"Content-type": "application/json"};

  const json =
      '[14.15096801, 5396.33385026,  90, 100.85063639, 4210.27282935,   950, 90.247584,   34090.35022757,  1290, 90.1312418,  34940.14757631,  1009]';

  final response =
      await http.post(Uri.parse(url), headers: headers, body: json);

  if (response.statusCode == 200) {
    var prediction = response.body.replaceAll("[", "");
    prediction = prediction.replaceAll("]", "");

    List<String> predictionList = prediction.split(' ');

    final predictedValue =
        predictionList.indexWhere((element) => element == "1.");

    print("Prediction: $predictedValue");

    return predictedValue.toString();
  } else {
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
    throw Exception('Failed to create prediction');
  }
}
