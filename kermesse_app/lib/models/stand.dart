import 'package:json_annotation/json_annotation.dart';
import 'package:kermesse_app/models/product.dart';

import 'kermesse.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'stand.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Stand {
  Stand(
      this.id,
      this.name,
      this.type,
      this.description,
      this.stock,
      this.pts_donnees,
      this.conso,
      this.jetonsRequis,
      this.kermesses,
      this.userID,
      );

  int id;
  String name;
  String type;
  String description;
  List<Product>? stock;
  int pts_donnees;
  int conso;
  int jetonsRequis;
  List<Kermesse>? kermesses;
  int userID;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Stand.fromJson(Map<String, dynamic> json) => _$StandFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$StandToJson(this);
}