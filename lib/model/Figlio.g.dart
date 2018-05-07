// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Figlio.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Figlio _$FiglioFromJson(Map<String, dynamic> json) => new Figlio()
  ..alu_id = json['alu_id'] as int
  ..alu_nome = json['alu_nome'] as String
  ..alu_cognome = json['alu_cognome'] as String
  ..alu_nascita = json['alu_nascita'] as String
  ..classe = json['classe'] == null
      ? null
      : new Classe.fromJson(json['classe'] as Map<String, dynamic>);

abstract class _$FiglioSerializerMixin {
  int get alu_id;
  String get alu_nome;
  String get alu_cognome;
  String get alu_nascita;
  Classe get classe;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'alu_id': alu_id,
        'alu_nome': alu_nome,
        'alu_cognome': alu_cognome,
        'alu_nascita': alu_nascita,
        'classe': classe
      };
}
