import 'package:http/http.dart' as http;

class HttpAdapter {
  Future<dynamic> getRequest() async {
    Uri url = Uri.https("official-joke-api.appspot.com", "/random_ten");

    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Error in GET request: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error in GET request: $e');
      return null;
    }
  }
}