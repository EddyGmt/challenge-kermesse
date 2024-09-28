import 'package:json_annotation/json_annotation.dart';
import 'package:kermesse_app/models/stand.dart';
import 'package:kermesse_app/models/user.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'kermesse.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Kermesse {
  Kermesse(
      this.id,
      this.name,
      this.stands,
      this.organisateurs,
      this.participants,
      this.userID
      );

  int id;
  String name;
  List<Stand> stands;
  List<User> organisateurs;
  List<User> participants;
  int userID;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Kermesse.fromJson(Map<String, dynamic> json) => _$KermesseFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$KermesseToJson(this);
}