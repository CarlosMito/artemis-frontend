enum ImageSaturation { random, high, low }

extension ParseToString on ImageSaturation {
  String toDisplay() {
    switch (this) {
      case ImageSaturation.random:
        return "Aleatório";
      case ImageSaturation.high:
        return "Cores Vibrantes";
      case ImageSaturation.low:
        return "Cores Pastéis";
      default:
        return name;
    }
  }
}
