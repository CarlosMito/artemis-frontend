import 'dart:convert';
import 'dart:developer';
import 'package:artemis/models/text2image/artemis_input_api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'api_constants.dart';

class ReplicateApiService {
  Future<Map<String, dynamic>?> postPrompt(String prompt) async {
    log('Gerando prompt: "$prompt"');

    Uri url = Uri.parse(ReplicateApiConstants.baseUrl + ReplicateApiConstants.endpoints.text2image);
    String? key = dotenv.env["REPLICATE_API_TOKEN"];
    Map<String, String> headers = {"Authorization": "Token $key"};
    Map<String, dynamic> body = {
      "version": "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf",
      "input": {"prompt": prompt}
    };

    String stringBody = jsonEncode(body);
    stringBody = '{"version": "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf", "input": {"prompt": "$prompt"}}';

    log(jsonEncode(body));
    log(url.toString());

    try {
      Response res = await http.post(url, headers: headers, body: stringBody);
      log("Status Code [POST]: ${res.statusCode.toString()}");

      if (res.statusCode == 201) {
        return jsonDecode(res.body);
      } else if (res.statusCode == 200) {
        // print(jsonDecode(res.body));
      }
    } catch (e) {
      log("Erro [POST]: $e");
    }

    return null;
  }

  Future<Map<String, dynamic>?> getStatus(String id) async {
    Uri url = Uri.parse("${ReplicateApiConstants.baseUrl}/${ReplicateApiConstants.endpoints.text2image}/$id");
    String? key = dotenv.env["REPLICATE_API_TOKEN"];
    Map<String, String> headers = {
      "Authorization": "Token $key",
      "Content-Type": "application/json",
    };

    try {
      Response res = await http.get(url, headers: headers);
      log("Status Code [GET]: ${res.statusCode.toString()}");

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      log("Erro [GET]: $e");
    }

    return null;
  }
}

class ArtemisApiService {
  static Future<Map<String, dynamic>?> postPrompt(ArtemisInputAPI input) async {
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.text2image}");

    // String? key = dotenv.env["REPLICATE_API_TOKEN"];
    // Map<String, String> headers = {"Authorization": "Token $key"};

    // Map<String, dynamic> body = {
    //   "version": "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf",
    //   "input": {"prompt": input}
    // };

    // TODO: Turn it into map body
    // input
    Map<String, dynamic> body = {};

    // String stringBody = jsonEncode(body);
    // stringBody = '{"version": "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf", "input": {"prompt": "$prompt"}}';

    // log(jsonEncode(body));
    // log(url.toString());

    try {
      Response res = await http.post(uri, body: body);
      log("Status Code [POST]: ${res.statusCode.toString()}");

      if (res.statusCode == 201) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      log("Erro [POST]: $e");
    }

    return null;
  }

  static Future<Map<String, dynamic>?> getStatus(List<String> idList) async {
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.text2image}");

    // String? key = dotenv.env["REPLICATE_API_TOKEN"];
    // Map<String, String> headers = {
    //   "Authorization": "Token $key",
    //   "Content-Type": "application/json",
    // };

    Map<String, List<String>> queryParameters = {
      "id": idList,
    };

    uri = uri.replace(queryParameters: queryParameters);
    log(uri.toString());

    try {
      Response res = await http.get(uri);
      log("Status Code [GET]: ${res.statusCode.toString()}");

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      log("Erro [GET]: $e");
    }

    return null;
  }
}