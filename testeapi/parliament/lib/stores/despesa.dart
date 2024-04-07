import 'package:flutter/material.dart';
import 'package:parliament/repositories/despesa.dart';
import 'package:parliament/services/exceptions.dart';

import '../models/despesa.dart';

class DespesaStore {

  final DespesaRepositorio repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Despesa>> state = ValueNotifier<List<Despesa>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  DespesaStore({required this.repository});

  Future getDespesas(int id) async {
    isLoading.value = true;
    try {
      final result = await repository.getDespesas(id);
      state.value = result;
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}