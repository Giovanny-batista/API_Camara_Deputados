class Despesa {

  final int ano;
  final int mes;
  final String tipo;
  final int codigoDocumento;
  final String tipoDocumento;
  final String dataDocumento;
  final String numeroDocumento;
  final double valorDocumento;
  final String urlDocumento;
  final String nomeFornecedor;

  Despesa({

    required this.ano,
    required this.mes,
    required this.tipo,
    required this.codigoDocumento,
    required this.tipoDocumento,
    required this.dataDocumento,
    required this.numeroDocumento,
    required this.valorDocumento,
    required this.urlDocumento,
    required this.nomeFornecedor,

  });

  factory Despesa.fromMap(Map<String, dynamic> map) {
    return Despesa(
      ano: map['ano'] ?? 0,
      mes: map['mes'] ?? 0,
      tipo: map['tipoDespesa'] ?? '',
      codigoDocumento: map['codDocumento'] ?? 0,
      tipoDocumento: map['tipoDocumento'] ?? '',
      dataDocumento: map['dataDocumento'] ?? '',
      numeroDocumento: map['numDocumento'] ?? '',
      valorDocumento: map['valorDocumento'] ?? 0.0,
      urlDocumento: map['urlDocumento'] ?? '',
      nomeFornecedor: map['nomeFornecedor'] ?? '',
    );
  }
}
