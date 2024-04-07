import 'dart:convert';

import '../models/informacao_deputado.dart';
import '../services/client.dart';
import '../services/exceptions.dart';

abstract class InformacaoDeputadoInterface {
  Future<InformacaoDeputado> getDeputado(int id);
}

class InformacaoDeputadoRepositorio implements InformacaoDeputadoInterface {

  final HttpInterface client;

  InformacaoDeputadoRepositorio({required this.client});

  @override
  Future<InformacaoDeputado> getDeputado(int id) async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados/$id',
    );

    if (response.statusCode == 200) {

      final body = jsonDecode(response.body);
      return InformacaoDeputado.fromMap(body['dados']);

    } else if (response.statusCode == 404) {

      throw NotFoundException('A url informada não foi encontrada');

    } else {

      throw Exception('Error: ${response.statusCode}');

    }
  }
}