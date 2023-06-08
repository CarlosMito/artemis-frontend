import 'dart:convert';
import 'dart:developer';
import 'package:artemis/models/text2image/artemis_input_api.dart';
import 'package:artemis/models/text2image/artemis_output_api.dart';
import 'package:artemis/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'api_constants.dart';

class ReplicateApiService {
  Future<Map<String, dynamic>?> postPrompt(String prompt) async {
    log('Gerando prompt: "$prompt"');

    Uri url = Uri.parse(ReplicateApiConstants.baseUrl + ReplicateApiConstants.endpoints.text2image!);
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

    Map<String, String> body = input.toJson();

    // String stringBody = jsonEncode(body);
    // stringBody = '{"version": "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf", "input": {"prompt": "$prompt"}}';

    log(jsonEncode(body));
    log(uri.toString());

    try {
      Response res = await http.post(uri, body: body);
      log("Status Code [POST]: ${res.statusCode.toString()}");

      if (res.statusCode == 201) {
        return jsonDecode(res.body);
      }

      log(res.body.toString());
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

  static Future<List<List<ArtemisOutputAPI>>?> getCreations(User user) async {
    Response response;
    String name = "getCreations";
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.inputs}/${user.id}");
    log("URL: ${uri.toString()}", name: name);

    // String? key = dotenv.env["REPLICATE_API_TOKEN"];
    // Map<String, String> headers = {
    //   "Authorization": "Token $key",
    //   "Content-Type": "application/json",
    // };

    try {
      response = await http.get(uri);
      log("Status Code: ${response.statusCode.toString()}", name: name);
      if (response.statusCode != 200) return null;
    } catch (e) {
      log("Error: $e", name: name);
      return null;
    }

    Map<int, ArtemisInputAPI> inputs = {};
    List<String> outputIds = [];

    for (var data in jsonDecode(response.body)) {
      try {
        inputs[data["id"]] = ArtemisInputAPI.fromJson(data);
        for (var outputId in data["outputs"]) {
          outputIds.add(outputId.toString());
        }
      } catch (e) {
        log("Parsing Error: $e", name: name);
      }
    }

    log("Total Inputs: ${inputs.length}", name: name);

    Map<String, List<String>> queryParameters = {"id": outputIds};
    uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.outputs}");
    uri = uri.replace(queryParameters: queryParameters);

    log("URL: ${uri.toString()}", name: name);

    try {
      response = await http.get(uri);
      log("Status Code: ${response.statusCode.toString()}", name: name);
      if (response.statusCode != 200) return null;
    } catch (e) {
      log("Error: $e", name: name);
      return null;
    }

    Map<int, List<ArtemisOutputAPI>> auxiliar = {};
    for (var data in jsonDecode(response.body)) {
      try {
        int inputId = data["input"];

        if (!auxiliar.containsKey(inputId)) {
          auxiliar[inputId] = [];
        }

        auxiliar[inputId]!.add(ArtemisOutputAPI.fromJson(data, inputs[inputId]!));
      } catch (e) {
        log("Parsing Error: $e", name: name);
      }
    }

    log("Total Outputs: ${outputIds.length}", name: name);

    return auxiliar.values.toList();
  }

  static void loginArtemis(String username, String password) async {
    String name = "loginArtemis";
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.login}");

    // String? key = dotenv.env["REPLICATE_API_TOKEN"];
    // Map<String, String> headers = {
    //   "Authorization": "Token $key",
    //   "Content-Type": "application/json",
    // };

    log("URL: ${uri.toString()}", name: name);

    Map<String, String> body = {
      "username": username,
      "password": password,
    };

    try {
      Response res = await http.post(uri, body: body);
      log("Status Code: ${res.statusCode.toString()}", name: name);

      if (res.statusCode == 200) {
        log(res.body, name: name);
        // return jsonDecode(res.body);
      }
    } catch (e) {
      log("Error: $e", name: name);
    }
  }

  static void logoutArtemis() async {
    String name = "logoutArtemis";
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.logout}");

    // String? key = dotenv.env["REPLICATE_API_TOKEN"];
    // Map<String, String> headers = {
    //   "Authorization": "Token $key",
    //   "Content-Type": "application/json",
    // };

    log("URL: ${uri.toString()}", name: name);

    try {
      Response res = await http.get(uri);
      log("Status Code: ${res.statusCode.toString()}", name: name);

      if (res.statusCode == 200) {
        log(res.body, name: name);
        // return jsonDecode(res.body);
      }
    } catch (e) {
      log("Error: $e", name: name);
    }
  }
}
