enum ImageStyle { anime, digitalArt, model3d, oilPainting, photography }

extension ParseToString on ImageStyle {
  String toDisplay() {
    switch (this) {
      case ImageStyle.anime:
        return "Anime";
      case ImageStyle.digitalArt:
        return "Arte Digital";
      case ImageStyle.model3d:
        return "Modelo 3D";
      case ImageStyle.oilPainting:
        return "Pintura a Óleo";
      case ImageStyle.photography:
        return "Fotografia";
      default:
        return name;
    }
  }
}
