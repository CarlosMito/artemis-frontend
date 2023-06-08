enum ImageDimensions { dim512, dim768 }

extension ParseToString on ImageDimensions {
  String toReplicateAPI() {
    String size = name.substring(3);
    return "${size}x$size";
  }
}

// NOTE: The current error is that the REPLICATE API NAME isn't equal to the name of the num, so the byName method doesn't work.
// extension ImageDimensionsByReplicate<T extends Enum> on Iterable<T> {
//   /// Finds the enum value in this list with name [name].
//   ///
//   /// Goes through this collection looking for an enum with
//   /// name [name], as reported by [EnumName.name].
//   /// Returns the first value with the given name. Such a value must be found.
//   T byName(String name) {
//     for (var value in this) {
//       if (value._name == name) return value;
//     }
//     throw ArgumentError.value(name, "name", "No enum value with that name");
//   }

//   /// Creates a map from the names of enum values to the values.
//   ///
//   /// The collection that this method is called on is expected to have
//   /// enums with distinct names, like the `values` list of an enum class.
//   /// Only one value for each name can occur in the created map,
//   /// so if two or more enum values have the same name (either being the
//   /// same value, or being values of different enum type), at most one of
//   /// them will be represented in the returned map.
//   Map<String, T> asNameMap() => <String, T>{for (var value in this) value._name: value};
// }
