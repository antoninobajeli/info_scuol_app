// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseEnvelop.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

ResponseEnvelop _$ResponseEnvelopFromJson(Map<String, dynamic> json) =>
    new ResponseEnvelop()
      ..success = json['success'] as bool
      ..message = json['message'] as String
      ..response = json['response'] as String
      ..user = json['user'] == null
          ? null
          : new IsaTutenze.fromJson(json['user'] as Map<String, dynamic>)
      ..lastInsertId = json['lastInsertId'] as int
      ..figli = (json['figli'] as List)
          ?.map((e) =>
              e == null ? null : new Figlio.fromJson(e as Map<String, dynamic>))
          ?.toList()
      ..classi = (json['classi'] as List)
          ?.map((e) =>
              e == null ? null : new Classe.fromJson(e as Map<String, dynamic>))
          ?.toList()
      ..scuole = (json['scuole'] as List)
          ?.map((e) =>
              e == null ? null : new Scuola.fromJson(e as Map<String, dynamic>))
          ?.toList()
      ..elencoclasse = (json['elencoclasse'] as List)
          ?.map((e) =>
              e == null ? null : new Alunno.fromJson(e as Map<String, dynamic>))
          ?.toList();

abstract class _$ResponseEnvelopSerializerMixin {
  bool get success;
  String get message;
  String get response;
  IsaTutenze get user;
  int get lastInsertId;
  List<Figlio> get figli;
  List<Classe> get classi;
  List<Scuola> get scuole;
  List<Alunno> get elencoclasse;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'success': success,
        'message': message,
        'response': response,
        'user': user,
        'lastInsertId': lastInsertId,
        'figli': figli,
        'classi': classi,
        'scuole': scuole,
        'elencoclasse': elencoclasse
      };
}
