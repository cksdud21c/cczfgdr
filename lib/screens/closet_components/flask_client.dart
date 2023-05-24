import 'dart:convert';
import 'package:http/http.dart' as http;

class FlaskClient {
  Future<List<String>> getClothingItems(String category, String id) async {
    var url = Uri.parse('http://34.66.37.198:5000/closet');
    var data = {'ID': id,'category': category};
    var body = json.encode(data);
    print(id);
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,

    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Response body: $jsonResponse'); // Add this line for debugging
      if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
        List<String> itemUrls = List<String>.from(jsonResponse['list']);
        return itemUrls;
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to get clothing items from the server');
    }
  }
}





