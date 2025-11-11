import 'package:http/http.dart' as http;
import 'dart:convert';

// This is the function that will fetch the cat image URL
Future<String> fetchCatImageUrl() async {
  // This is the URL for TheCatAPI endpoint that gives a random image
  final url = Uri.parse('https://api.thecatapi.com/v1/images/search');

  print('Fetching cat image...');

  try {
    // Make the network request. We 'await' it to complete.
    final response = await http.get(url);

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // The response body is a JSON string.
      // jsonDecode turns it into a Dart object.
      // TheCatAPI returns a list, so we get a List<dynamic>.
      final List<dynamic> data = jsonDecode(response.body);

      // The list contains one object, and that object has a 'url' key.
      final imageUrl = data[0]['url'] as String;

      print('Success! Image URL: $imageUrl');
      return imageUrl;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('Failed to load cat image. Status code: ${response.statusCode}');
      throw Exception('Failed to load cat image');
    }
  } catch (e) {
    // This catches any errors during the http request (e.g., no internet)
    print('Error fetching cat image: $e');
    throw Exception('Error: $e');
  }
}

// You can use a main function like this to test it
void main() async {
  await fetchCatImageUrl();
}
