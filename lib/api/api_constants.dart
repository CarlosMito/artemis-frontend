class ReplicateApiConstants {
  static const String baseUrl = "https://api.replicate.com";
  static const Endpoints endpoints = Endpoints(
    text2image: "v1/predictions",
  );
}

class ArtemisApiConstants {
  static const String baseUrl = "http://localhost:8000";
  static const Endpoints endpoints = Endpoints(
    text2image: "api/text2image",
    outputs: "api/output",
  );
}

class Endpoints {
  final String? text2image;
  final String? outputs;
  const Endpoints({this.text2image, this.outputs});
}
