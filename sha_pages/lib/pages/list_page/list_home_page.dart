// ignore_for_file: library_private_types_in_public_api, unused_local_variable, depend_on_referenced_packages, avoid_function_literals_in_foreach_calls, avoid_print
import 'package:flutter/material.dart';
import 'package:sha_compartilhados/cores/cores.dart';
import 'package:sha_compartilhados/fontes/fontes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sha_models/models/lista/lista_model.dart';
import 'package:sha_pages/pages/list_page/list_check_page.dart';

class ListHomePage extends StatefulWidget {
  const ListHomePage({Key? key}) : super(key: key);

  @override
  _ListHomePageState createState() => _ListHomePageState();
}

class ListItem {
  final String nome;
  final String texto;

  ListItem({
    required this.nome,
    required this.texto,
  });
}

class _ListHomePageState extends State<ListHomePage> {
  late List<ListaModel> listas;

  @override
  void initState() {
    listas = [];
    _carregarListasDoFirebase();
    super.initState();
  }

  Future<void> _carregarListasDoFirebase() async {
    setState(() {
      listas.clear();
    });

    try {
      CollectionReference listasCollection =
          FirebaseFirestore.instance.collection('listas');

      QuerySnapshot<Map<String, dynamic>> listasQuerySnapshot =
          await listasCollection.get() as QuerySnapshot<Map<String, dynamic>>;

      listasQuerySnapshot.docs.forEach(
        (DocumentSnapshot<Map<String, dynamic>> doc) {
          Map<String, dynamic> data = doc.data()!;
          listas.add(
            ListaModel(
              cod: null,
              nome: data['nome'] ?? '',
              itens: (data['itens'] as List?)?.cast<String>(),
              textAux: (data['itens'] as List?)?.join(', ') ?? '',
            ),
          );
        },
      );

      setState(() {});
    } catch (e) {
      print('Erro ao carregar listas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Cores.corPrincipal,
      body: ListView.builder(
        itemCount: listas.length,
        itemBuilder: (context, index) {
          final item = listas[index];
          return ListTile(
            title: Text(
              item.nome!,
              style: Fontes.getMontserrat(cor: Cores.corTextoBranco),
            ),
            subtitle: Text(
              item.textAux!,
              style: Fontes.getMontserrat(cor: Cores.corTextoBranco),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListCheckPage(lista: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
