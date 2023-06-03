class ReplicateApiConstants {
  static const String baseUrl = "https://api.replicate.com";
  static const Endpoints endpoints = Endpoints("v1/predictions");
}

class ArtemisApiConstants {
  static const String baseUrl = "http://localhost:8000";
  static const Endpoints endpoints = Endpoints("api/text2image");
}

class Endpoints {
  final String text2image;
  const Endpoints(this.text2image);
}
