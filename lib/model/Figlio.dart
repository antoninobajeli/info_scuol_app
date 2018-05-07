import 'package:json_annotation/json_annotation.dart';
import 'Classe.dart';

/// This allows our `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'Figlio.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

/// Every json_serializable class must have the serializer mixin.
/// It makes the generated toJson() method to be usable for the class.
/// The mixin's name follows the source class, in this case, User.
class Figlio extends Object with _$FiglioSerializerMixin {
   int
  alu_id;
   String
  alu_nome,
  alu_cognome,
  alu_nascita;

  Classe classe;


  Figlio();

  /// A necessary factory constructor for creating a new User instance
  /// from a map. We pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory Figlio.fromJson(Map<String, dynamic> json) => _$FiglioFromJson(json);

}
