// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'InfoResp.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

InfoResp _$InfoRespFromJson(Map<String, dynamic> json) => new InfoResp()
  ..response = (json['response'] as List)
      ?.map((e) =>
          e == null ? null : new Info.fromJson(e as Map<String, dynamic>))
      ?.toList();

abstract class _$InfoRespSerializerMixin {
  List<Info> get response;
  Map<String, dynamic> toJson() => <String, dynamic>{'response': response};
}
