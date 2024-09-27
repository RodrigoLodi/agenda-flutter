import 'package:flutter/material.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> contatos = [];

  // Função para adicionar ou editar contato.
  void adicionarOuEditarContato({Map<String, String>? contato, int? index}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPage(contato: contato),
      ),
    );

    if (resultado != null) {
      if (resultado['deletar'] == true && index != null) {
        setState(() {
          contatos.removeAt(index);
        });
      } else if (index == null) {
        setState(() {
          contatos.add(resultado);
        });
      } else {
        setState(() {
          contatos[index] = resultado;
        });
      }
    }
  }

  // Função para deletar contato da lista
  void deletarContato(int index) {
    setState(() {
      contatos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agenda Telefônica')),
      body: contatos.isEmpty
          ? Center(
              child: Text(
                'Nenhum contato adicionado',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: contatos.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      contatos[index]['nome']!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${contatos[index]['telefone']} - ${contatos[index]['email']}'),
                    onTap: () => adicionarOuEditarContato(contato: contatos[index], index: index),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => deletarContato(index),
                    ),
                  ),
                );
              },
            ),
      // Botão flutuante para adicionar um novo contato
      floatingActionButton: FloatingActionButton(
        onPressed: () => adicionarOuEditarContato(),
        child: Icon(Icons.add),
      ),
    );
  }
}
