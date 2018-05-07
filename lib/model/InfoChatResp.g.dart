// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'InfoChatResp.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

InfoChatResp _$InfoChatRespFromJson(
        Map<String, dynamic> json) =>
    new InfoChatResp()
      ..response = (json['response'] as List)
          ?.map((e) => e == null
              ? null
              : new InfoChat.fromJson(e as Map<String, dynamic>))
          ?.toList();

abstract class _$InfoChatRespSerializerMixin {
  List<InfoChat> get response;
  Map<String, dynamic> toJson() => <String, dynamic>{'response': response};
}
