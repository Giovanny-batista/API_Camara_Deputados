import 'package:flutter/material.dart';
import 'package:parliament/repositories/comissao.dart';
import 'package:parliament/services/client.dart';
import 'package:parliament/stores/comissao.dart';

class Comissao extends StatefulWidget {
  const Comissao({Key? key}) : super(key: key);

  @override
  State<Comissao> createState() => _ComissaoState();
}

class _ComissaoState extends State<Comissao> {
  final ComissaoStore store = ComissaoStore(
    repository: ComissaoRepositorio(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    store.getComissao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          'Comissões',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.green,
        child: AnimatedBuilder(
          animation: store.isLoading,
          builder: (context, child) {
            if (store.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            }

            if (store.error.value.isNotEmpty) {
              return Center(
                child: Text(store.error.value),
              );
            }

            return ListView.builder(
              itemCount: store.state.value.length,
              itemBuilder: (context, index) {
                final comissao = store.state.value[index];
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.95,
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 230, 228, 228), 
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  comissao.titulo,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                FutureBuilder(
                                  future: store.repository.getComissaoDeputados(comissao.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                        ),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(snapshot.error.toString()),
                                      );
                                    }

                                    final List<dynamic> deputados = snapshot.data as List<dynamic>;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: deputados.map((deputado) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 16),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                child: ClipOval(
                                                  child: Image.network(
                                                    deputado['urlFoto'],
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      deputado['nome'],
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      deputado['titulo'],
                                                    ),
                                                    Text(
                                                      '${deputado['siglaPartido']} - ${deputado['siglaUf']}',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blue,
                      ),
                    ),
                    margin: const EdgeInsets.all(4),
                    child: ListTile(
                      title: Text(
                        comissao.titulo,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
