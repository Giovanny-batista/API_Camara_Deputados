import 'package:flutter/material.dart';

import 'package:parliament/repositories/comissao.dart';
import 'package:parliament/services/exceptions.dart';
import '../models/comissao.dart';

class ComissaoStore {

  final ComissaoRepositorio repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Comissao>> state = ValueNotifier<List<Comissao>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  ComissaoStore({required this.repository});

  Future getComissao() async {

    isLoading.value = true;

    try {
      final result = await repository.getComissao();
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