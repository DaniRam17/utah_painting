import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpAdapter {
  Future<dynamic> getRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception("Error en la solicitud: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en la solicitud HTTP: $e");
      return null;
    }
  }

  Future<String?> getRandomProfilePic() async {
    try {
      String url = "https://randomuser.me/api/";
      String? response = await getRequest(url);
      if (response != null) {
        Map<String, dynamic> data = jsonDecode(response);
        return data["results"][0]["picture"]["large"];
      }
    } catch (e) {
      print("Error obteniendo imagen aleatoria: $e");
    }
    return "https://via.placeholder.com/150";
  }
}
