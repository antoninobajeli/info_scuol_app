import 'package:json_annotation/json_annotation.dart';

/// This allows our `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'Info.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

/// Every json_serializable class must have the serializer mixin.
/// It makes the generated toJson() method to be usable for the class.
/// The mixin's name follows the source class, in this case, User.
class Info extends Object with _$InfoSerializerMixin {
  int
  inf_id,inf_cla_id,inf_priority,inf_categoria,infrcp_id, ade_id,ade_scelta;

  String
  inf_titolo,
  inf_descr;

  DateTime inf_date_start;
  DateTime inf_date_end;
  String cla_descr,
  infrcp_received_ts;


  //using = YesNoDeserializer())
  bool inf_adesione=null;


  //@JsonDeserialize(using = YesNoDeserializer.class)
  bool infrcp_read=null;


  Info({this.inf_id, this.inf_titolo, this.inf_descr, this.inf_date_start, this.inf_date_end});
  /// A necessary factory constructor for creating a new User instance
  /// from a map. We pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

}
