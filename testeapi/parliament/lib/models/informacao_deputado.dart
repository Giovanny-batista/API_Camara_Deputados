class InformacaoDeputado {
  final String? apelido;
  final String? nomeCivil;
  final String? cpf;
  final String? sexo;
  final String? dataNascimento;
  final String? ufNascimento;
  final String? cidadeNascimento;
  final String? educacao;

  InformacaoDeputado({
    this.apelido,
    this.nomeCivil,
    this.cpf,
    this.sexo,
    this.dataNascimento,
    this.ufNascimento,
    this.cidadeNascimento,
    this.educacao,
  });

  factory InformacaoDeputado.fromMap(Map<String, dynamic> map) =>
      InformacaoDeputado(
        apelido: map['ultimoStatus']['nomeEleitoral'] ?? '',
        nomeCivil: map['nomeCivil'] ?? '',
        cpf: map['cpf'] ?? '',
        sexo: map['sexo'] ?? '',
        dataNascimento: map['dataNascimento'] ?? '',
        ufNascimento: map['ufNascimento'] ?? '',
        cidadeNascimento: map['municipioNascimento'] ?? '',
        educacao: map['escolaridade'] ?? '',
      );
}
