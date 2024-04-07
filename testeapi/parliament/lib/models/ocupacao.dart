class Ocupacao {

  final String titulo;
  final String entidade;
  final String ufEntidade;
  final String paisEntidade;
  final String anoInicio;
  final String anoFim;

  Ocupacao({

    required this.titulo,
    required this.entidade,
    required this.ufEntidade,
    required this.paisEntidade,
    required this.anoInicio,
    required this.anoFim,

  });

  factory Ocupacao.fromMap(Map<String, dynamic> map) {
    return Ocupacao(
      titulo: map['titulo'] ?? '',
      entidade: map['entidade'] ?? '',
      ufEntidade: map['entidadeUF'] ?? '',
      paisEntidade: map['entidadePais'] ?? '',
      anoInicio: map['anoInicio'].toString(),
      anoFim: map['anoFim'].toString(),
    );
  }
}
