import 'package:flutter/material.dart';
import 'package:parliament/repositories/deputado.dart';
import 'package:parliament/stores/deputado.dart';
import '../models/deputado.dart';
import '../routes/router.dart' as routes;
import '../services/client.dart';

class Deputados extends StatefulWidget {
  const Deputados({Key? key});

  @override
  State<Deputados> createState() => _DeputadoState();
}

class _DeputadoState extends State<Deputados> {
  final DeputadoStore store = DeputadoStore(
    repository: DeputadoRepositorio(
      client: HttpClient(),
    ),
  );

  late TextEditingController _searchController;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    store.getDeputados();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Deputado> filterDeputado(List<Deputado> deputado, String query) {
    return deputado
        .where((deputado) =>
            deputado.nome.toLowerCase().contains(query.toLowerCase()) ||
            deputado.partido.toLowerCase().contains(query.toLowerCase()) ||
            deputado.uf.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 80, 174, 111), 
      appBar: AppBar(
        title: Text('Lista de Deputados'),
        backgroundColor: Color.fromARGB(255, 80, 174, 111),  
        elevation: 0, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  isSearching = value.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Pesquisar',
                hintText: 'Pesquisar deputado por nome, partido',
                filled: true,
                fillColor: Color.fromARGB(255, 251, 251, 251),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search),
                suffixIcon: isSearching
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            isSearching = false;
                          });
                        },
                      )
                    : null,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: AnimatedBuilder(
                animation: Listenable.merge(
                  [
                    store.isLoading,
                    store.state,
                    store.error,
                  ],
                ),
                builder: (context, child) {
                  if (store.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 135, 199, 252)),
                      ),
                    );
                  }

                  if (store.error.value.isNotEmpty) {
                    return Center(
                      child: Text(store.error.value),
                    );
                  }

                  if (store.state.value.isEmpty) {
                    return Center(
                      child: Text('Nenhum deputado encontrado.'),
                    );
                  }

                  final filteredDeputados = filterDeputado(store.state.value, _searchController.text);
                  filteredDeputados.sort((a, b) => a.nome.compareTo(b.nome));

                  return ListView.builder(
                    itemCount: filteredDeputados.length,
                    itemBuilder: (context, index) {
                      final deputado = filteredDeputados[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              routes.deputadoDethais,
                              arguments: deputado,
                            );
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(deputado.foto),
                            radius: 30,
                          ),
                          title: Text(
                            deputado.nome,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            '${deputado.partido} - ${deputado.uf}',
                            style: TextStyle(
                              color: Color.fromARGB(255, 47, 47, 47),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
