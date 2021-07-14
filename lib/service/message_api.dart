import 'dart:convert';
import 'package:http/http.dart' as http;

class MessageApi {
  Future<bool> sendMessage(String senderId, String message) async {
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "user_id": "89",
      "created_date": "067",
      "sender_id": "98",
      "body": message
    };
    String jsonBody = json.encode(body);
    var response = await http.post(
        "https://www.dakshsolarenergy.com/message/public/api/message/store",
        headers: headers,
        body: jsonBody);
    if (response.statusCode == 200) {
      print(response.statusCode);
      return true;
    } else
      return false;
  }
}
