import 'package:flutter/material.dart';
import 'package:parliament/models/deputado.dart';
import 'package:parliament/stores/despesa.dart';
import 'package:parliament/stores/ocupacao.dart';
import 'package:parliament/stores/informacao_deputado.dart';

import '../repositories/despesa.dart';
import '../repositories/ocupacao.dart';
import '../repositories/informacao_deputado.dart';
import '../services/client.dart';

class InformacaoDeputado extends StatefulWidget {
  final Deputado deputado;
  const InformacaoDeputado({Key? key, required this.deputado}) : super(key: key);

  @override
  State<InformacaoDeputado> createState() => _InformacaoDeputadoState();
}

class _InformacaoDeputadoState extends State<InformacaoDeputado> {
  double imageSize = 100.0; 

  final InformacaoDeputadoStore detailsStore = InformacaoDeputadoStore(
    repository: InformacaoDeputadoRepositorio(
      client: HttpClient(),
    ),
  );

  final DespesaStore expenseStore = DespesaStore(
    repository: DespesaRepositorio(
      client: HttpClient(),
    ),
  );

  final OcupacaoStore ocupacaoStore = OcupacaoStore(
    repository: OcupacaoRepositorio(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    detailsStore.getInformacaoDeputado(widget.deputado.id);
    expenseStore.getDespesas(widget.deputado.id);
    ocupacaoStore.getOcupacao(widget.deputado.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Deputado'),
        backgroundColor: Colors.green,
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          detailsStore.isLoading,
          detailsStore.state,
          detailsStore.error,
          expenseStore.isLoading,
          expenseStore.state,
          expenseStore.error,
          ocupacaoStore.isLoading,
          ocupacaoStore.state,
          ocupacaoStore.error,
        ]),
        builder: (context, child) {
          if (detailsStore.isLoading.value ||
              expenseStore.isLoading.value ||
              ocupacaoStore.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          if (detailsStore.error.value.isNotEmpty ||
              expenseStore.error.value.isNotEmpty ||
              ocupacaoStore.error.value.isNotEmpty) {
            return Center(
              child: Text(detailsStore.error.value +
                  expenseStore.error.value +
                  ocupacaoStore.error.value),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      imageSize = imageSize == 100.0 ? 200.0 : 100.0;
                    });
                  },
                  child: Hero(
                    tag: 'imageHero', 
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            width: imageSize, 
                            height: imageSize, 
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                widget.deputado.foto,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.deputado.nome,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showCardDialog(
                        context,
                        'Partido: ${widget.deputado.partido}\n'
                        'Estado: ${widget.deputado.uf}\n'
                        'Legislatura: ${widget.deputado.legislatura}\n'
                        'Email: ${widget.deputado.email}\n'
                        'URI: ${widget.deputado.uri}');
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Partido: ${widget.deputado.partido}', style: TextStyle(color: Colors.black)),
                          Text('Estado: ${widget.deputado.uf}', style: TextStyle(color: Colors.black)),
                          Text('Legislatura: ${widget.deputado.legislatura}', style: TextStyle(color: Colors.black)),
                          Text('Email: ${widget.deputado.email}', style: TextStyle(color: Colors.black)),
                          Text('URI: ${widget.deputado.uri}', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showCardDialog(
                        context,
                        'Nome Civil: ${detailsStore.state.value.nomeCivil}\n'
                        'Nome Eleitoral: ${detailsStore.state.value.apelido}\n'
                        'CPF: ${detailsStore.state.value.cpf}\n'
                        'Data de nascimento: ${detailsStore.state.value.dataNascimento}\n'
                        'Escolaridade: ${detailsStore.state.value.educacao}');
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nome Civil: ${detailsStore.state.value.nomeCivil}', style: TextStyle(color: Colors.black)),
                          Text('Nome Eleitoral: ${detailsStore.state.value.apelido}', style: TextStyle(color: Colors.black)),
                          Text('CPF: ${detailsStore.state.value.cpf}', style: TextStyle(color: Colors.black)),
                          Text('Data de nascimento: ${detailsStore.state.value.dataNascimento}', style: TextStyle(color: Colors.black)),
                          Text('Escolaridade: ${detailsStore.state.value.educacao}', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showCardDialog(
                      context,
                      'Despesas:\n'
                      '${expenseStore.state.value.map((expense) => 
                      'Tipo: ${expense.tipo}\n'
                      'Fornecedor: ${expense.nomeFornecedor}\n'
                      'Valor: ${expense.valorDocumento}\n'
                      'Data: ${expense.dataDocumento}\n\n'
                      ).join()}',
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Despesas',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, color: Colors.grey),
                            ],
                          ),
                        ),
                        Container(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: expenseStore.state.value.length,
                            itemBuilder: (context, index) {
                              final expense = expenseStore.state.value[index];
                              return Container(
                                width: 365,
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color.fromARGB(255, 0, 0, 0)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tipo: ${expense.tipo}', style: const TextStyle(color: Colors.black, fontSize: 12)),
                                    Text('Fornecedor: ${expense.nomeFornecedor}', style: const TextStyle(color: Colors.black, fontSize: 12)),
                                    Text('Valor: ${expense.valorDocumento}', style: const TextStyle(color: Colors.black, fontSize: 12)),
                                    Text('Data: ${expense.dataDocumento}', style: const TextStyle(color: Colors.black, fontSize: 12)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showCardDialog(
                      context,
                      'Ocupações:\n'
                      '${ocupacaoStore.state.value.map((occupation) => 
                      'Nome: ${occupation.titulo}\n'
                      'Entidade: ${occupation.entidade == '' ? 'Não informado' : occupation.entidade}\n'
                      'Data de início: ${occupation.anoInicio == 'null' ? 'Não informado' : occupation.anoInicio}\n'
                      'Data de fim: ${occupation.anoInicio == 'null' && occupation.anoFim == 'null' ? 'Não Informado' : occupation.anoFim == 'null' ? 'Até o momento' : occupation.anoFim}\n\n'
                      ).join()}',
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ocupações',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, color: Colors.grey),
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ocupacaoStore.state.value.length,
                            itemBuilder: (context, index) {
                              final occupation = ocupacaoStore.state.value[index];
                              return Container(
                                width: 365,
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color.fromARGB(255, 0, 2, 4)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nome: ${occupation.titulo}', style: const TextStyle(color: Colors.black, fontSize: 12)),
                                    Text('Entidade: ${occupation.entidade == '' ? 'Não informado' : occupation.entidade}', style: const TextStyle(color: Colors.black, fontSize: 12)),
                                    Text('Data de início: ${occupation.anoInicio == 'null' ? 'Não informado' : occupation.anoInicio}', style: const TextStyle(color: Colors.black, fontSize: 12)),
                                    Text('Data de fim: ${occupation.anoInicio == 'null' && occupation.anoFim == 'null' ? 'Não Informado' : occupation.anoFim == 'null' ? 'Até o momento' : occupation.anoFim}', style: const TextStyle(color: Colors.black, fontSize: 12)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  
  void _showCardDialog(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300], 
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
