import 'dart:convert';

import '../models/despesa.dart';
import '../services/client.dart';
import '../services/exceptions.dart';

abstract class DespesaInterface {
  Future<List<Despesa>> getDespesas(int id);
}

class DespesaRepositorio implements DespesaInterface {

  final HttpInterface client;

  DespesaRepositorio({required this.client});

  @override
  Future<List<Despesa>> getDespesas(int id) async {

    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/despesas',
    );

    if (response.statusCode == 200) {

      final List<Despesa> despesas = [];
      final body = jsonDecode(response.body);

      body['dados'].map((despesa) {
        despesas.add(Despesa.fromMap(despesa));
      }).toList();

      return despesas;

    } else if (response.statusCode == 404) {

      throw NotFoundException('A url informada não foi encontrada');

    } else {

      throw Exception('Error: ${response.statusCode}');

    }

  }

}