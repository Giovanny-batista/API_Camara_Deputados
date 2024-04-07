import 'package:flutter/material.dart';

import 'package:parliament/repositories/deputado.dart';
import 'package:parliament/services/exceptions.dart';
import '../models/deputado.dart';

class DeputadoStore {

  final DeputadoRepositorio repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Deputado>> state = ValueNotifier<List<Deputado>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  DeputadoStore({required this.repository});

  Future getDeputados() async {

    isLoading.value = true;

    try {
      final result = await repository.getDeputados();
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