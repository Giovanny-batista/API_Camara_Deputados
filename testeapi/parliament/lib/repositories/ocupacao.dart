import 'dart:convert';

import '../models/ocupacao.dart';
import '../services/client.dart';
import '../services/exceptions.dart';

abstract class OcupacaoInterface {
  Future<List<Ocupacao>> getOcupacao(int id);
}

class OcupacaoRepositorio implements OcupacaoInterface {
  final HttpInterface client;

  OcupacaoRepositorio({required this.client});

  @override
  Future<List<Ocupacao>> getOcupacao(int id) async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/ocupacoes',
    );

    if (response.statusCode == 200) {
      final List<Ocupacao> ocupacoes = [];
      final body = jsonDecode(response.body);

      if (body['dados'] != null) {
        body['dados'].forEach((ocupacao) {
          ocupacoes.add(Ocupacao.fromMap(ocupacao));
        });
      }

      return ocupacoes;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A URL informada não foi encontrada');
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }
}
