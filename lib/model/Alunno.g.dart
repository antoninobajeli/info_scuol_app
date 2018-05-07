// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Alunno.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Alunno _$AlunnoFromJson(Map<String, dynamic> json) => new Alunno()
  ..claalu_cla_id = json['claalu_cla_id'] as int
  ..alu_id = json['alu_id'] as int
  ..alu_cognome = json['alu_cognome'] as String
  ..alu_nome = json['alu_nome'] as String
  ..alu_nascita = json['alu_nascita'] as String
  ..genitori = (json['genitori'] as List)
      ?.map((e) =>
          e == null ? null : new IsaTutenze.fromJson(e as Map<String, dynamic>))
      ?.toList();

abstract class _$AlunnoSerializerMixin {
  int get claalu_cla_id;
  int get alu_id;
  String get alu_cognome;
  String get alu_nome;
  String get alu_nascita;
  List<IsaTutenze> get genitori;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'claalu_cla_id': claalu_cla_id,
        'alu_id': alu_id,
        'alu_cognome': alu_cognome,
        'alu_nome': alu_nome,
        'alu_nascita': alu_nascita,
        'genitori': genitori
      };
}
