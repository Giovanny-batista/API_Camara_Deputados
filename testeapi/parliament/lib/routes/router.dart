import 'package:flutter/material.dart';
import 'package:parliament/screens/comissao.dart';
import 'package:parliament/screens/deputado.dart';

import '../models/deputado.dart';
import '../screens/home.dart';
import '../screens/informacao_deputado.dart';

const String home = '/';
const String deputados = '/deputado';
const String deputadoDethais = '/deputados';
const String comissao = '/comissao';

Route controller(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const Home());
    case '/deputado':
      return MaterialPageRoute(builder: (context) => const Deputados());
    case '/deputados':
      return MaterialPageRoute(builder: (context) => InformacaoDeputado(deputado: settings.arguments as Deputado));
    case '/comissao':
      return MaterialPageRoute(builder: (context) => const Comissao());
    default:
      return MaterialPageRoute(builder: (context) => const Home());
  }
}
