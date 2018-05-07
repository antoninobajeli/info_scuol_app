// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RequestEnvelop.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

RequestEnvelop _$RequestEnvelopFromJson(Map<String, dynamic> json) =>
    new RequestEnvelop()
      ..requestingDevice = json['requestingDevice'] as String
      ..userToLogin = json['userToLogin'] == null
          ? null
          : new IsaTutenze.fromJson(json['userToLogin'] as Map<String, dynamic>)
      ..infoUteAdesione = json['infoUteAdesione'] == null
          ? null
          : new InfoUteAdesione.fromJson(
              json['infoUteAdesione'] as Map<String, dynamic>)
      ..sessionToken = json['sessionToken'] as String
      ..newInfo = json['newInfo'] == null
          ? null
          : new Info.fromJson(json['newInfo'] as Map<String, dynamic>)
      ..newAlunno = json['newAlunno'] == null
          ? null
          : new Alunno.fromJson(json['newAlunno'] as Map<String, dynamic>)
      ..infrcpInfo = json['infrcpInfo'] == null
          ? null
          : new InfrcpInfo.fromJson(json['infrcpInfo'] as Map<String, dynamic>)
      ..ute_id = json['ute_id'] as int
      ..cla_id = json['cla_id'] as int
      ..inf_id = json['inf_id'] as int
      ..infcha_mex = json['infcha_mex'] as String
      ..ist_codice = json['ist_codice'] as String
      ..ist_id = json['ist_id'] as int
      ..scu_codice = json['scu_codice'] as String
      ..scu_id = json['scu_id'] as int
      ..classe = json['classe'] == null
          ? null
          : new Classe.fromJson(json['classe'] as Map<String, dynamic>);

abstract class _$RequestEnvelopSerializerMixin {
  String get requestingDevice;
  IsaTutenze get userToLogin;
  InfoUteAdesione get infoUteAdesione;
  String get sessionToken;
  Info get newInfo;
  Alunno get newAlunno;
  InfrcpInfo get infrcpInfo;
  int get ute_id;
  int get cla_id;
  int get inf_id;
  String get infcha_mex;
  String get ist_codice;
  int get ist_id;
  String get scu_codice;
  int get scu_id;
  Classe get classe;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'requestingDevice': requestingDevice,
        'userToLogin': userToLogin,
        'infoUteAdesione': infoUteAdesione,
        'sessionToken': sessionToken,
        'newInfo': newInfo,
        'newAlunno': newAlunno,
        'infrcpInfo': infrcpInfo,
        'ute_id': ute_id,
        'cla_id': cla_id,
        'inf_id': inf_id,
        'infcha_mex': infcha_mex,
        'ist_codice': ist_codice,
        'ist_id': ist_id,
        'scu_codice': scu_codice,
        'scu_id': scu_id,
        'classe': classe
      };
}
