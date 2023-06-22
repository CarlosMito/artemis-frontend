// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

void downloadFileFromUrl(String url) {
  html.AnchorElement anchorElement = html.AnchorElement(href: url);
  anchorElement.download = url;
  anchorElement.click();
}

void downloadFileFromBytes(String filename, List<int> bytes) {
  final base64Data = base64.encode(bytes);

  // Save the zip file
  html.AnchorElement()
    ..href = 'data:application/zip;base64,$base64Data'
    ..download = filename
    ..click();
}

Future<Uint8List> readImageAsBytes(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  return response.bodyBytes;
}
