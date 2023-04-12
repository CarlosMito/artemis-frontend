import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'api_constants.dart';

class ApiService {
  Future<String> postPrompt(String prompt) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.predictionEndpoint);
      var key = dotenv.env["REPLICATE_API_TOKEN"];

      Map<String, String> headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type,Authorization",
        "Access-Control-Allow-Methods": "POST",
        "Authorization": "Token $key",
        "Content-Type": "application/x-www-form-urlencoded",
      };

      Map<String, String> body = {
        "version": "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf",
        "input": jsonEncode({"prompt": prompt})
      };

      log(body.toString());

      var res = await http.post(url, headers: headers, body: body);
      log("Status code: ${res.statusCode.toString()}");

      if (res.statusCode == 200) {
        log(res.body);
        // return jsonDecode(res.body);
        return "A";
      }
    } catch (e) {
      log(e.toString());
    }

    return "B";
  }

  // Future<List<Object>?> getStatus() async {}
}
