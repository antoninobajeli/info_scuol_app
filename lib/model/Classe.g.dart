// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Classe.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Classe _$ClasseFromJson(Map<String, dynamic> json) => new Classe()
  ..cla_id = json['cla_id'] as int
  ..cla_ordinale = json['cla_ordinale'] == null
      ? null
      : OrdinaliClassi.values.singleWhere(
          (x) => x.toString() == 'OrdinaliClassi.${json['cla_ordinale']}')
  ..cla_descr = json['cla_descr'] as String
  ..cla_sezione = json['cla_sezione'] as String
  ..cla_anno = json['cla_anno'] as String
  ..cla_iban_fondocassa = json['cla_iban_fondocassa'] as String
  ..scuola = json['scuola'] == null
      ? null
      : new Scuola.fromJson(json['scuola'] as Map<String, dynamic>)
  ..capoclasse = json['capoclasse'] == null
      ? null
      : new Capoclasse.fromJson(json['capoclasse'] as Map<String, dynamic>);

abstract class _$ClasseSerializerMixin {
  int get cla_id;
  OrdinaliClassi get cla_ordinale;
  String get cla_descr;
  String get cla_sezione;
  String get cla_anno;
  String get cla_iban_fondocassa;
  Scuola get scuola;
  Capoclasse get capoclasse;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'cla_id': cla_id,
        'cla_ordinale':
            cla_ordinale == null ? null : cla_ordinale.toString().split('.')[1],
        'cla_descr': cla_descr,
        'cla_sezione': cla_sezione,
        'cla_anno': cla_anno,
        'cla_iban_fondocassa': cla_iban_fondocassa,
        'scuola': scuola,
        'capoclasse': capoclasse
      };
}
