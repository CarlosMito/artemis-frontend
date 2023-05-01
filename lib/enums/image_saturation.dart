enum ImageSaturation { high, low }

extension ParseToString on ImageSaturation {
  String toDisplay() {
    switch (this) {
      case ImageSaturation.high:
        return "Cores Vibrantes";
      case ImageSaturation.low:
        return "Cores Pastéis";
      default:
        return name;
    }
  }
}
