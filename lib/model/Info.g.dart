// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Info.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Info _$InfoFromJson(Map<String, dynamic> json) => new Info(
    inf_id: json['inf_id'] as int,
    inf_titolo: json['inf_titolo'] as String,
    inf_descr: json['inf_descr'] as String,
    inf_date_start: json['inf_date_start'] == null
        ? null
        : DateTime.parse(json['inf_date_start'] as String),
    inf_date_end: json['inf_date_end'] == null
        ? null
        : DateTime.parse(json['inf_date_end'] as String))
  ..inf_cla_id = json['inf_cla_id'] as int
  ..inf_priority = json['inf_priority'] as int
  ..inf_categoria = json['inf_categoria'] as int
  ..infrcp_id = json['infrcp_id'] as int
  ..ade_id = json['ade_id'] as int
  ..ade_scelta = json['ade_scelta'] as int
  ..cla_descr = json['cla_descr'] as String
  ..infrcp_received_ts = json['infrcp_received_ts'] as String
  ..inf_adesione = json['inf_adesione'] as bool
  ..infrcp_read = json['infrcp_read'] as bool;

abstract class _$InfoSerializerMixin {
  int get inf_id;
  int get inf_cla_id;
  int get inf_priority;
  int get inf_categoria;
  int get infrcp_id;
  int get ade_id;
  int get ade_scelta;
  String get inf_titolo;
  String get inf_descr;
  DateTime get inf_date_start;
  DateTime get inf_date_end;
  String get cla_descr;
  String get infrcp_received_ts;
  bool get inf_adesione;
  bool get infrcp_read;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'inf_id': inf_id,
        'inf_cla_id': inf_cla_id,
        'inf_priority': inf_priority,
        'inf_categoria': inf_categoria,
        'infrcp_id': infrcp_id,
        'ade_id': ade_id,
        'ade_scelta': ade_scelta,
        'inf_titolo': inf_titolo,
        'inf_descr': inf_descr,
        'inf_date_start': inf_date_start?.toIso8601String(),
        'inf_date_end': inf_date_end?.toIso8601String(),
        'cla_descr': cla_descr,
        'infrcp_received_ts': infrcp_received_ts,
        'inf_adesione': inf_adesione,
        'infrcp_read': infrcp_read
      };
}
