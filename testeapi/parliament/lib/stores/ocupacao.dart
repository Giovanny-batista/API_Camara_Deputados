import 'package:flutter/material.dart';
import 'package:parliament/models/ocupacao.dart';
import 'package:parliament/repositories/ocupacao.dart';

class OcupacaoStore {
  final OcupacaoRepositorio repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Ocupacao>> state = ValueNotifier<List<Ocupacao>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  OcupacaoStore({required this.repository});

  Future<void> getOcupacao(int id) async {
    isLoading.value = true;
    try {
      final result = await repository.getOcupacao(id);
      state.value = result;
    } on Exception catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
