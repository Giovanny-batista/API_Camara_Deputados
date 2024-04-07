import 'dart:convert';

import '../models/comissao.dart';
import '../services/client.dart';
import '../services/exceptions.dart';

abstract class ComissaoInterface {
  Future<List<Comissao>> getComissao();
}

class ComissaoRepositorio implements ComissaoInterface {

  final HttpInterface client;

  ComissaoRepositorio({required this.client});

  Future<Map<String, dynamic>> getComissaoDetalhe(int id) async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/frentes/$id',
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<List<dynamic> > getComissaoDeputados(int id) async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/frentes/$id/membros',
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['dados'];
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  @override
  Future<List<Comissao>> getComissao() async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/frentes',
    );

    if (response.statusCode == 200) {
      final List<Comissao> comissoes = [];
      final body = jsonDecode(response.body);

      body['dados'].forEach((comissao) {
        comissoes.add(Comissao.fromMap(comissao));
      });

      return comissoes;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

}
