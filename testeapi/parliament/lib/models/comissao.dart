class Comissao {

  final int id;
  final String uri;
  final String titulo;
  final int legislatura;

  late final Map<String, dynamic> detalhes;
  late final List<dynamic> deputados;

  Comissao({
    required this.id,
    required this.uri,
    required this.titulo,
    required this.legislatura,
    this.detalhes = const {},
    this.deputados = const [],
  });

  factory Comissao.fromMap(Map<String, dynamic> map) {
    return Comissao(
      id: map['id'],
      uri: map['uri'],
      titulo: map['titulo'],
      legislatura: map['idLegislatura'],
    );
  }

}
