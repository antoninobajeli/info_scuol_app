import 'package:json_annotation/json_annotation.dart';
import 'Scuola.dart';
import 'Capoclasse.dart';
import 'Enums.dart';

/// This allows our `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'Classe.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

/// Every json_serializable class must have the serializer mixin.
/// It makes the generated toJson() method to be usable for the class.
/// The mixin's name follows the source class, in this case, User.
class Classe extends Object with _$ClasseSerializerMixin {


  int cla_id;
  OrdinaliClassi cla_ordinale;

  String cla_descr, cla_sezione,cla_anno, cla_iban_fondocassa;
  Scuola scuola;
  Capoclasse capoclasse;

  Classe();

  /// A necessary factory constructor for creating a new User instance
  /// from a map. We pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory Classe.fromJson(Map<String, dynamic> json) => _$ClasseFromJson(json);

}
