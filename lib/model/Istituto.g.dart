// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Istituto.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Istituto _$IstitutoFromJson(Map<String, dynamic> json) => new Istituto()
  ..ist_id = json['ist_id'] as int
  ..ist_dir_tut_id = json['ist_dir_tut_id'] as int
  ..ist_codice = json['ist_codice'] as String
  ..ist_nome = json['ist_nome'] as String
  ..ist_email = json['ist_email'] as String
  ..ist_dirigente = json['ist_dirigente'] as String
  ..ist_iban = json['ist_iban'] as String
  ..ist_indirizzo = json['ist_indirizzo'] as String
  ..ist_tel = json['ist_tel'] as String
  ..scuole = (json['scuole'] as List)
      ?.map((e) =>
          e == null ? null : new Scuola.fromJson(e as Map<String, dynamic>))
      ?.toList();

abstract class _$IstitutoSerializerMixin {
  int get ist_id;
  int get ist_dir_tut_id;
  String get ist_codice;
  String get ist_nome;
  String get ist_email;
  String get ist_dirigente;
  String get ist_iban;
  String get ist_indirizzo;
  String get ist_tel;
  List<Scuola> get scuole;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'ist_id': ist_id,
        'ist_dir_tut_id': ist_dir_tut_id,
        'ist_codice': ist_codice,
        'ist_nome': ist_nome,
        'ist_email': ist_email,
        'ist_dirigente': ist_dirigente,
        'ist_iban': ist_iban,
        'ist_indirizzo': ist_indirizzo,
        'ist_tel': ist_tel,
        'scuole': scuole
      };
}
