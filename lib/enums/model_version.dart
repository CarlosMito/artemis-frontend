enum StableDiffusionVersion {
  v2_1("db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf"),
  v2_1Safe("f178fa7a1ae43a9a9af01b833b9d2ecf97b1bcb0acfd2dc5dd04895e042863f1"),
  v2_0("0827b64897df7b6e8c04625167bbb275b9db0f14ab09e2454b9824141963c966"),
  v1_5("328bd9692d29d6781034e3acab8cf3fcb122161e6f5afb896a4ca9fd57090577"),
  v1_4("a826166bdfbd1c12981a2e914120aa8c19ab2b5474ff8c70f4e2923e6d6596cc");

  final String value;
  const StableDiffusionVersion(this.value);
}
