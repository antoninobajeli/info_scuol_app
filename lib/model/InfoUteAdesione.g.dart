// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'InfoUteAdesione.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

InfoUteAdesione _$InfoUteAdesioneFromJson(Map<String, dynamic> json) =>
    new InfoUteAdesione()
      ..ade_id = json['ade_id'] as int
      ..ade_inf_id = json['ade_inf_id'] as int
      ..ade_tut_id = json['ade_tut_id'] as int
      ..ade_scelta = json['ade_scelta'] as int;

abstract class _$InfoUteAdesioneSerializerMixin {
  int get ade_id;
  int get ade_inf_id;
  int get ade_tut_id;
  int get ade_scelta;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'ade_id': ade_id,
        'ade_inf_id': ade_inf_id,
        'ade_tut_id': ade_tut_id,
        'ade_scelta': ade_scelta
      };
}
