import 'dart:convert';

import 'package:parliament/services/client.dart';
import '../models/deputado.dart';
import '../services/exceptions.dart';

abstract class DeputadoInterface {
  Future<List<Deputado>> getDeputados();
}

class DeputadoRepositorio implements DeputadoInterface {
  final HttpInterface client;

  DeputadoRepositorio({
    required this.client,
  });

  @override
  Future<List<Deputado>> getDeputados() async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados',
    );

    if (response.statusCode == 200) {
      final List<Deputado> deputados = [];
      final body = jsonDecode(response.body);

      body['dados'].map((deputado) {
        deputados.add(Deputado.fromMap(deputado));
      }).toList();

      return deputados;

    } else if (response.statusCode == 404) {

      throw NotFoundException('A url informada não foi encontrada');

    } else {

      throw Exception('Error: ${response.statusCode}');

    }
  }
}