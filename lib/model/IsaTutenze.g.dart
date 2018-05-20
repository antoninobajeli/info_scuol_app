// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IsaTutenze.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

IsaTutenze _$IsaTutenzeFromJson(Map<String, dynamic> json) => new IsaTutenze()
  ..gen_id = json['gen_id'] as int
  ..gen_scu = json['gen_scu'] as String
  ..gen_email = json['gen_email'] as String
  ..gen_pwd = json['gen_pwd'] as String
  ..gen_nome = json['gen_nome'] as String
  ..gen_cognome = json['gen_cognome'] as String
  ..gen_cell = json['gen_cell'] as String
  ..gen_madre = json['gen_madre'] as bool
  ..gen_padre = json['gen_padre'] as bool
  ..gen_leader = json['gen_leader'] as bool
  ..gen_logged = json['gen_logged'] as bool
  ..gen_login_tkn = json['gen_login_tkn'] as String
  ..gen_push_token_gl = json['gen_push_token_gl'] as String
  ..gen_push_token_itune = json['gen_push_token_itune'] as String;

abstract class _$IsaTutenzeSerializerMixin {
  int get gen_id;
  String get gen_scu;
  String get gen_email;
  String get gen_pwd;
  String get gen_nome;
  String get gen_cognome;
  String get gen_cell;
  bool get gen_madre;
  bool get gen_padre;
  bool get gen_leader;
  bool get gen_logged;
  String get gen_login_tkn;
  String get gen_push_token_gl;
  String get gen_push_token_itune;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'gen_id': gen_id,
        'gen_scu': gen_scu,
        'gen_email': gen_email,
        'gen_pwd': gen_pwd,
        'gen_nome': gen_nome,
        'gen_cognome': gen_cognome,
        'gen_cell': gen_cell,
        'gen_madre': gen_madre,
        'gen_padre': gen_padre,
        'gen_leader': gen_leader,
        'gen_logged': gen_logged,
        'gen_login_tkn': gen_login_tkn,
        'gen_push_token_gl': gen_push_token_gl,
        'gen_push_token_itune': gen_push_token_itune
      };
}
