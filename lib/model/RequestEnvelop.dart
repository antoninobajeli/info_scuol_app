import 'package:json_annotation/json_annotation.dart';
import 'IsaTutenze.dart';
import 'Alunno.dart';
import 'InfrcpInfo.dart';
import 'Classe.dart';
import 'InfoUteAdesione.dart';
import 'Info.dart';

/// This allows our `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'RequestEnvelop.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

/// Every json_serializable class must have the serializer mixin.
/// It makes the generated toJson() method to be usable for the class.
/// The mixin's name follows the source class, in this case, User.
class RequestEnvelop extends Object with _$RequestEnvelopSerializerMixin {


  String requestingDevice = "";
  IsaTutenze userToLogin;
  InfoUteAdesione infoUteAdesione;
  String sessionToken;
  Info newInfo = null;
  Alunno newAlunno = null;
  InfrcpInfo infrcpInfo = null;
  int ute_id,cla_id, inf_id;
  String infcha_mex;
  String ist_codice;
  int ist_id;
  String scu_codice;
  int scu_id;

  Classe classe;

  RequestEnvelop();

  /// A necessary factory constructor for creating a new User instance
  /// from a map. We pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory RequestEnvelop.fromJson(Map<String, dynamic> json) => _$RequestEnvelopFromJson(json);

}
