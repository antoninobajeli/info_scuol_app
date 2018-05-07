
enum WorkingMode { rappresentante, genitore, insegnante, dirigente }
enum TipoScuola  { scuola_dell_infansia, scuola_primaria, scuola_secondria, scuola_superiore}

enum OrdinaliClassi {I,II,III,IV,V}

String OrdinaliClassiGetDescription(OrdinaliClassi val){
  switch (val) {
    case OrdinaliClassi.I:
      return "Prima";
    case OrdinaliClassi.II:
      return "Seconda";
    case OrdinaliClassi.III:
      return "Terza";
    case OrdinaliClassi.IV:
      return "Quarta";
    case OrdinaliClassi.V:
      return "Quinta";
  }
}

String OrdinaliClassiGetShortDescription(OrdinaliClassi val){
  switch (val) {
    case OrdinaliClassi.I:
      return "I";
    case OrdinaliClassi.II:
      return "II";
    case OrdinaliClassi.III:
      return "III";
    case OrdinaliClassi.IV:
      return "IV";
    case OrdinaliClassi.V:
      return "V";
  }
}

String TipoScuolaGetDescription(TipoScuola val){
  switch (val) {
    case TipoScuola.scuola_superiore:
      return "Scuuola superiore";
    case TipoScuola.scuola_primaria:
      return "Scuola primaria";
    case TipoScuola.scuola_dell_infansia:
      return "Scuola dell'infansia";
    case TipoScuola.scuola_secondria:
      return "Scuola secondaria";
  }
}

