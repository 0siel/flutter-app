import 'package:http/http.dart' as http;
import "dart:convert";

Future<List<String>> fetchCatImages() async {
  final url = Uri.parse('https://api.thecatapi.com/v1/images/search?limit=10');
  print('Fetching 10 cat images...');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // wtf jsonDecode response.body is List<dynamic>
      final List<dynamic> data = jsonDecode(response.body);
      //print('okokoko$data');
      return data.map((item) => item['url'] as String).toList();
    } else {
      throw Exception('Failed to fetch images: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching cat images: $e');
    throw Exception('Error: $e');
  }
}
