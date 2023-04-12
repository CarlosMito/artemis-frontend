import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'api_constants.dart';

class ApiService {
  Future<Map<String, dynamic>?> postPrompt(String prompt) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.predictionEndpoint);
      var key = dotenv.env["REPLICATE_API_TOKEN"];

      Map<String, String> headers = {
        "Authorization": "Token $key",
        "Content-Type": "application/json",
      };

      Map<String, Object> body = {
        "version": "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf",
        "input": {"prompt": prompt}
      };

      var res = await http.post(url, headers: headers, body: body);

      if (res.statusCode == 200) {
        print(res.body);
        log(res.body);
        return jsonDecode(res.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Object>?> getStatus() async {}
}
