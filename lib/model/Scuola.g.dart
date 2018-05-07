// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Scuola.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Scuola _$ScuolaFromJson(Map<String, dynamic> json) => new Scuola()
  ..scu_id = json['scu_id'] as int
  ..scu_codice = json['scu_codice'] as String
  ..scu_nome = json['scu_nome'] as String
  ..scu_tipo = json['scu_tipo'] == null
      ? null
      : TipoScuola.values
          .singleWhere((x) => x.toString() == 'TipoScuola.${json['scu_tipo']}')
  ..istituto = json['istituto'] == null
      ? null
      : new Istituto.fromJson(json['istituto'] as Map<String, dynamic>);

abstract class _$ScuolaSerializerMixin {
  int get scu_id;
  String get scu_codice;
  String get scu_nome;
  TipoScuola get scu_tipo;
  Istituto get istituto;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'scu_id': scu_id,
        'scu_codice': scu_codice,
        'scu_nome': scu_nome,
        'scu_tipo': scu_tipo == null ? null : scu_tipo.toString().split('.')[1],
        'istituto': istituto
      };
}
