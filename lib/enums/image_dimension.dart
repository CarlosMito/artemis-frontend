enum ImageDimensions { dim512, dim768 }

extension ParseToString on Enum {
  String toReplicateAPI() {
    String size = name.substring(3);
    return "${size}x$size";
  }
}

extension EnumByReplicateName on Iterable<ImageDimensions> {
  ImageDimensions byReplicateName(String replicateName) {
    for (var value in this) {
      if (value.toReplicateAPI() == replicateName) return value;
    }
    throw ArgumentError.value(replicateName, "name", "No enum value with that name");
  }
}
