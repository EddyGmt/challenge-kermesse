import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'product.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Product {
  Product(
      this.id,
      this.name,
      this.picture,
      this.type,
      this.jetonsRequis,
      this.nbProducts,
      this.standID,
      );

  int id;
  String name;
  String picture;
  String type;
  int jetonsRequis;
  int nbProducts;
  int standID;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}