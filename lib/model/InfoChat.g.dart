// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'InfoChat.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

InfoChat _$InfoChatFromJson(Map<String, dynamic> json) => new InfoChat()
  ..infcha_id = json['infcha_id'] as int
  ..infcha_info_id = json['infcha_info_id'] as int
  ..infcha_gen_id = json['infcha_gen_id'] as int
  ..infrcp_id = json['infrcp_id'] as int
  ..infrcp_read = json['infrcp_read'] as int
  ..infcha_timestamp = json['infcha_timestamp'] as String
  ..infcha_mex = json['infcha_mex'] as String
  ..infcha_gen_name = json['infcha_gen_name'] as String
  ..infrcp_received_ts = json['infrcp_received_ts'] as String;

abstract class _$InfoChatSerializerMixin {
  int get infcha_id;
  int get infcha_info_id;
  int get infcha_gen_id;
  int get infrcp_id;
  int get infrcp_read;
  String get infcha_timestamp;
  String get infcha_mex;
  String get infcha_gen_name;
  String get infrcp_received_ts;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'infcha_id': infcha_id,
        'infcha_info_id': infcha_info_id,
        'infcha_gen_id': infcha_gen_id,
        'infrcp_id': infrcp_id,
        'infrcp_read': infrcp_read,
        'infcha_timestamp': infcha_timestamp,
        'infcha_mex': infcha_mex,
        'infcha_gen_name': infcha_gen_name,
        'infrcp_received_ts': infrcp_received_ts
      };
}
