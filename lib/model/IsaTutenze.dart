import 'package:json_annotation/json_annotation.dart';

/// This allows our `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'IsaTutenze.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

/// Every json_serializable class must have the serializer mixin.
/// It makes the generated toJson() method to be usable for the class.
/// The mixin's name follows the source class, in this case, User.
class IsaTutenze extends Object with _$IsaTutenzeSerializerMixin {
  //IsaUtenze(this.name, this.email);

  /// Tell json_serializable that "registration_date_millis" should be
  /// mapped to this property.
  /*@JsonKey(name: 'registration_date_millis')
  final int registrationDateMillis;*/


   int gen_id;
   String gen_scu;
   String gen_email;
   String gen_pwd;
   String gen_nome;
   String gen_cognome;
   String gen_cell;
   bool gen_madre=false;
   bool gen_padre=false;
   bool gen_leader=false;
   bool gen_logged=false;
   String gen_login_tkn;


   IsaTutenze();




   /// A necessary factory constructor for creating a new User instance
  /// from a map. We pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory IsaTutenze.fromJson(Map<String, dynamic> json) => _$IsaTutenzeFromJson(json);
}

/*
@JsonLiteral('data.json')
Map get glossaryData => _$glossaryDataJsonLiteral;
*/