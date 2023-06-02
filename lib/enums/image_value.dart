enum ImageValue { random, high, low }

extension ParseToString on ImageValue {
  String toDisplay() {
    switch (this) {
      case ImageValue.random:
        return "Aleatório";
      case ImageValue.high:
        return "Tema Claro";
      case ImageValue.low:
        return "Tema Escuro";
      default:
        return name;
    }
  }
}
