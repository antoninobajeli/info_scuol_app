// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'InfrcpInfo.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

InfrcpInfo _$InfrcpInfoFromJson(Map<String, dynamic> json) => new InfrcpInfo()
  ..infrcp_id = json['infrcp_id'] as int
  ..infrcp_info_id = json['infrcp_info_id'] as int
  ..infrcp_gen_id = json['infrcp_gen_id'] as int
  ..infcha_timestamp = json['infcha_timestamp'] as String
  ..infrcp_received_ts = json['infrcp_received_ts'] as String
  ..infrcp_read = json['infrcp_read'] as String;

abstract class _$InfrcpInfoSerializerMixin {
  int get infrcp_id;
  int get infrcp_info_id;
  int get infrcp_gen_id;
  String get infcha_timestamp;
  String get infrcp_received_ts;
  String get infrcp_read;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'infrcp_id': infrcp_id,
        'infrcp_info_id': infrcp_info_id,
        'infrcp_gen_id': infrcp_gen_id,
        'infcha_timestamp': infcha_timestamp,
        'infrcp_received_ts': infrcp_received_ts,
        'infrcp_read': infrcp_read
      };
}
