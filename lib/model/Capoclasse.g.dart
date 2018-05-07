// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Capoclasse.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Capoclasse _$CapoclasseFromJson(Map<String, dynamic> json) => new Capoclasse()
  ..cpcl_id = json['cpcl_id'] as int
  ..cpcl_email = json['cpcl_email'] as String
  ..cpcl_cognome = json['cpcl_cognome'] as String
  ..cpcl_nome = json['cpcl_nome'] as String;

abstract class _$CapoclasseSerializerMixin {
  int get cpcl_id;
  String get cpcl_email;
  String get cpcl_cognome;
  String get cpcl_nome;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'cpcl_id': cpcl_id,
        'cpcl_email': cpcl_email,
        'cpcl_cognome': cpcl_cognome,
        'cpcl_nome': cpcl_nome
      };
}
