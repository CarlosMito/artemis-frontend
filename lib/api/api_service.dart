import 'dart:convert';
import 'dart:developer';
import 'package:artemis/models/text2image/artemis_input_api.dart';
import 'package:artemis/models/text2image/artemis_output_api.dart';
import 'package:artemis/models/user.dart';
import 'package:artemis/utils/maps.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'api_constants.dart';

// class ReplicateApiService {
//   Future<Map<String, dynamic>?> postPrompt(String prompt) async {
//     log('Gerando prompt: "$prompt"');

//     Uri url = Uri.parse(ReplicateApiConstants.baseUrl + ReplicateApiConstants.endpoints.text2image!);
//     String? key = dotenv.env["REPLICATE_API_TOKEN"];
//     Map<String, String> headers = {"Authorization": "Token $key"};
//     Map<String, dynamic> body = {
//       "version": "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf",
//       "input": {"prompt": prompt}
//     };

//     String stringBody = jsonEncode(body);
//     stringBody = '{"version": "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf", "input": {"prompt": "$prompt"}}';

//     log(jsonEncode(body));
//     log(url.toString());

//     try {
//       Response res = await http.post(url, headers: headers, body: stringBody);
//       log("Status Code [POST]: ${res.statusCode.toString()}");

//       if (res.statusCode == 201) {
//         return jsonDecode(res.body);
//       } else if (res.statusCode == 200) {
//         // print(jsonDecode(res.body));
//       }
//     } catch (e) {
//       log("Erro [POST]: $e");
//     }

//     return null;
//   }

//   Future<Map<String, dynamic>?> getStatus(String id) async {
//     Uri url = Uri.parse("${ReplicateApiConstants.baseUrl}/${ReplicateApiConstants.endpoints.text2image}/$id");
//     String? key = dotenv.env["REPLICATE_API_TOKEN"];
//     Map<String, String> headers = {
//       "Authorization": "Token $key",
//       "Content-Type": "application/json",
//     };

//     try {
//       Response res = await http.get(url, headers: headers);
//       log("Status Code [GET]: ${res.statusCode.toString()}");

//       if (res.statusCode == 200) {
//         return jsonDecode(res.body);
//       }
//     } catch (e) {
//       log("Erro [GET]: $e");
//     }

//     return null;
//   }
// }

class ArtemisApiService {
  static Future<String?> fetchCSRFToken() async {
    Response response;
    dynamic jsonBody;
    String name = "fetchCSRFToken";
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.csrf}");
    log("URL: ${uri.toString()}", name: name);

    // debugPrint(response.headers.toString());
    // debugPrint(response.body.toString());
    // log(data.toString());

    try {
      response = await http.get(uri);
      jsonBody = jsonDecode(response.body);
      log("Status Code: ${response.statusCode.toString()}", name: name);
      if (response.statusCode != 200) {
        log("Error: ${response.body}", name: name);
        return null;
      }
    } catch (e) {
      log("Error: $e", name: name);
      return null;
    }

    if (!jsonBody.containsKey("csrfToken")) {
      log("Error: Failed to fetch CSRF token", name: name);
      return null;
    }

    return jsonBody["csrfToken"]!;
  }

  static Future<int?> postPrompt(ArtemisInputAPI input) async {
    Response response;
    String name = "postPrompt";
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.text2image}");
    log("URL: ${uri.toString()}", name: name);

    Map<String, String> body = input.toJson();
    debugPrint(jsonEncode(body));

    String? csrfToken = await ArtemisApiService.fetchCSRFToken();

    if (csrfToken == null) {
      return null;
    }

    Map<String, String> headers = {'X-CSRFToken': csrfToken};

    try {
      response = await http.post(uri, body: body, headers: headers);
      log("Status Code: ${response.statusCode.toString()}", name: name);
      if (response.statusCode != 201) {
        log("Error: ${response.body}", name: name);
        return null;
      }
    } catch (e) {
      log("Error: $e", name: name);
      return null;
    }

    log("Response: ${response.body}", name: name);

    return jsonDecode(response.body)["id"];
  }

  static Future<Map<String, dynamic>?> updateStatus(String inputId) async {
    Response response;
    String name = "updateStatus";
    Map<String, String> queryParameters = {"input_id": inputId};
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.text2image}");
    uri = uri.replace(queryParameters: queryParameters);

    log(uri.toString(), name: name);

    try {
      response = await http.get(uri);
      log("Status Code: ${response.statusCode.toString()}", name: name);
      if (response.statusCode != 200 && response.statusCode != 410) {
        log("Error: ${response.body}", name: name);
        return null;
      }
    } catch (e) {
      log("Error: $e", name: name);
      return null;
    }

    var jsonBody = jsonDecode(response.body);
    debugPrint(jsonBody.toString());

    return jsonBody;
  }

  static Future<bool> postProcessing(String inputId) async {
    Response response;
    String name = "postProcessing";
    Map<String, String> queryParameters = {"input_id": inputId};
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.postProcessing}");
    uri = uri.replace(queryParameters: queryParameters);

    log(uri.toString(), name: name);

    Map<String, String> body = {"inputId": inputId};
    debugPrint(jsonEncode(body));

    String? csrfToken = await ArtemisApiService.fetchCSRFToken();

    if (csrfToken == null) {
      return false;
    }

    Map<String, String> headers = {'X-CSRFToken': csrfToken};

    try {
      response = await http.post(uri, body: body, headers: headers);
      log("Status Code: ${response.statusCode.toString()}", name: name);
      if (response.statusCode != 201) {
        log("Error: ${response.body}", name: name);
        return false;
      }
    } catch (e) {
      log("Error: $e", name: name);
      return false;
    }

    // var jsonBody = jsonDecode(response.body);
    // debugPrint(jsonBody.toString());

    return true;
  }

  static Future<List<List<ArtemisOutputAPI>>?> getCreations() async {
    Response response;
    String name = "getCreations";

    User? user = await ArtemisApiService.getLoggedInUserArtemis();

    if (user == null) {
      log("No user currently logged in", name: name);
      return null;
    }

    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.inputs}/${user.id}");
    log("URL: ${uri.toString()}", name: name);

    try {
      response = await http.get(uri);
      log("Status Code: ${response.statusCode.toString()}", name: name);
      if (response.statusCode != 200) {
        log("Error: ${response.body}", name: name);
        return null;
      }
    } catch (e) {
      log("Error: $e", name: name);
      return null;
    }

    log(jsonDecode(response.body).toString(), name: name);
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
    log(inputs.keys.toString(), name: name);

    if (inputs.isEmpty) {
      return [];
    }

    Map<String, List<String>> queryParameters = {"id": outputIds};
    uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.outputs}");
    uri = uri.replace(queryParameters: queryParameters);

    log("URL: ${uri.toString()}", name: name);

    try {
      response = await http.get(uri);
      log("Status Code: ${response.statusCode.toString()}", name: name);
      if (response.statusCode != 200) {
        log("Error: ${response.body}", name: name);
        return null;
      }
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

        data["image"] = "$mediaRoot${data['image']}";
        log(data["image"], name: name);

        auxiliar[inputId]!.add(ArtemisOutputAPI.fromJson(data, inputs[inputId]!));
      } catch (e) {
        log("Parsing Error: $e", name: name);
      }
    }

    log("Total Outputs: ${outputIds.length}", name: name);

    return auxiliar.values.toList();
  }

  static Future<User?> loginArtemis(String username, String password) async {
    Response response;
    String name = "loginArtemis";
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.login}");

    log("URL: ${uri.toString()}", name: name);

    Map<String, String> body = {
      "username": username,
      "password": password,
    };

    try {
      response = await http.post(uri, body: body);
      log("Status Code: ${response.statusCode.toString()}", name: name);

      if (response.statusCode != 200) {
        log(response.body, name: name);
        return null;
      }
    } catch (e) {
      log("Error: $e", name: name);
      return null;
    }

    log("Success: ${response.body}", name: name);
    return User.fromJson(jsonDecode(response.body));
  }

  static Future<void> logoutArtemis() async {
    Response response;
    String name = "logoutArtemis";
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.logout}");

    log("URL: ${uri.toString()}", name: name);

    try {
      response = await http.get(uri);
      log("Status Code: ${response.statusCode.toString()}", name: name);

      if (response.statusCode == 200) {
        log(response.body, name: name);
        // return jsonDecode(res.body);
      }
    } catch (e) {
      log("Error: $e", name: name);
    }
  }

  static Future<Map<String, String>> signupArtemis(String username, String email, String password, String confirmPassword) async {
    Response response;
    String name = "signupArtemis";
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.signup}");
    log(uri.toString(), name: name);

    Map<String, String> body = {
      "username": username,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
    };

    debugPrint(jsonEncode(body));

    try {
      response = await http.post(uri, body: body);
      log("Status Code: ${response.statusCode.toString()}", name: name);
      if (response.statusCode != 201) {
        log("Error: ${response.body}", name: name);
        // debugPrint(response.body);

        String errorMessage = "";

        if (response.body.contains("auth_user_username_key")) {
          errorMessage = "Username already exists!";
        }

        // log(response.body.runtimeType.toString());
        // debugPrint(response.body);
        // debugPrint(jsonDecode(response.body));
        return {"error": errorMessage};
      }
    } catch (e) {
      log("Error: $e", name: name);
      return {"error": "Request error!"};
    }

    return {"message": jsonDecode(response.body)["message"]};
  }

  static Future<User?> getLoggedInUserArtemis() async {
    Response response;
    String name = "getLoggedInUserArtemis";
    Uri uri = Uri.parse("${ArtemisApiConstants.baseUrl}/${ArtemisApiConstants.endpoints.loggedUser}");
    log(uri.toString(), name: name);

    try {
      response = await http.get(uri);
      log("Status Code: ${response.statusCode.toString()}", name: name);
      if (response.statusCode != 200) {
        log("Error: ${response.body}", name: name);
        return null;
      }
    } catch (e) {
      log("Error: $e", name: name);
      return null;
    }

    log("Success: ${response.body}", name: name);
    return User.fromJson(jsonDecode(response.body));
  }
}
