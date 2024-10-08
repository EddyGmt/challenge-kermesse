import 'package:json_annotation/json_annotation.dart';
import 'package:kermesse_app/models/stand.dart';
import 'package:kermesse_app/models/transaction.dart';
import 'history.dart';
import 'kermesse.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'user.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class User {
  User(this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.password,
      this.picture,
      this.role,
      this.jetons,
      this.parents,
      this.enfants,
      this.kermesses,
      this.stands,
      this.transactions,
      this.historique,);

  int? id;
  String firstname;
  String lastname;
  String email;
  String password;
  String picture;
  int role;
  int jetons;
  List<User>? parents;
  List<User>? enfants;
  List<Kermesse>? kermesses;
  List<Stand>? stands ;
  List<Transaction>? transactions;
  List<History>? historique;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}