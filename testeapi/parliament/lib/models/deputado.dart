class Deputado {

  final int id;
  final String uri;
  final String nome;
  final String partido;
  final String uf;
  final int legislatura;
  final String foto;
  final String email;

  Deputado({

    required this.id,
    required this.uri,
    required this.nome,
    required this.partido,
    required this.uf,
    required this.legislatura,
    required this.foto,
    required this.email,

  });

  factory Deputado.fromMap(Map<String, dynamic> map) {
    return Deputado(
      id: map['id'] ?? 0,
      uri: map['uri'] ?? '',
      nome: map['nome'] ?? '',
      partido: map['siglaPartido'] ?? '',
      uf: map['siglaUf'] ?? '',
      legislatura: map['idLegislatura'] ?? 0,
      foto: map['urlFoto'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String? get urlFoto => null;

  get selecionado => null;
}
