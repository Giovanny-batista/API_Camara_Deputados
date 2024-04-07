import 'package:flutter/material.dart';
import 'package:parliament/repositories/informacao_deputado.dart';

import '../models/informacao_deputado.dart';

class InformacaoDeputadoStore {

  final InformacaoDeputadoRepositorio repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<InformacaoDeputado> state = ValueNotifier<InformacaoDeputado>(InformacaoDeputado());
  final ValueNotifier<String> error = ValueNotifier<String>('');

  InformacaoDeputadoStore({required this.repository});

  Future getInformacaoDeputado(int id) async {
    isLoading.value = true;
    try {
      final result = await repository.getDeputado(id);
      state.value = result;
    } on Exception catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

}