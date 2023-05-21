enum ImageStyle { anime, digitalArt, model3d, oilPainting, photography, surrealism, comic, impressionist, graffiti, popArt }

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
      case ImageStyle.surrealism:
        return "Surrealista";
      case ImageStyle.comic:
        return "Quadrinhos";
      case ImageStyle.impressionist:
        return "Impressionista";
      case ImageStyle.graffiti:
        return "Grafiti";
      case ImageStyle.popArt:
        return "Arte Pop";
    }
  }
}
