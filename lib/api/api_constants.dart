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
    outputs: "api/outputs",
    inputs: "api/inputs",
    login: "api/login",
    logout: "api/logout",
    csrf: "api/csrf",
    signup: "api/signup",
    postProcessing: "api/post-processing",
    loggedUser: "api/logged-in-user",
    publicOutputs: "api/public-outputs",
  );
}

class Endpoints {
  final String? text2image;
  final String? outputs;
  final String? inputs;
  final String? login;
  final String? logout;
  final String? csrf;
  final String? postProcessing;
  final String? signup;
  final String? loggedUser;
  final String? publicOutputs;

  const Endpoints({
    this.text2image,
    this.outputs,
    this.inputs,
    this.login,
    this.logout,
    this.csrf,
    this.postProcessing,
    this.signup,
    this.loggedUser,
    this.publicOutputs,
  });
}
