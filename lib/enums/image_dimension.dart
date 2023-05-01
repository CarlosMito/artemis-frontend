
enum ImageDimension { dim512, dim768 }

extension ParseToString on ImageDimension {
  String toReplicateAPI() {
    String size = name.substring(3);
    return "${size}x$size";
  }
}
