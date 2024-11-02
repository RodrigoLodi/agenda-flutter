import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'form_page.dart';
import 'login_page.dart';
import '../services/db_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> contatos = [];

  @override
  void initState() {
    super.initState();
    _carregarContatos();
  }

  // Carrega contatos do banco de dados
  void _carregarContatos() async {
    final data = await DBHelper.buscarContatos();
    setState(() {
      contatos = data;
    });
  }

  // Função para adicionar ou editar contato
  void adicionarOuEditarContato({Map<String, dynamic>? contato, int? index}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPage(contato: contato),
      ),
    );

    if (resultado != null) {
      if (resultado['deletar'] == true && contato != null) {
        await DBHelper.deletarContato(contato['id']);
      } else if (contato == null) {
        await DBHelper.inserirContato({
          'nome': resultado['nome'],
          'telefone': resultado['telefone'],
          'email': resultado['email'],
        });
      } else {
        await DBHelper.atualizarContato({
          'id': contato['id'],
          'nome': resultado['nome'],
          'telefone': resultado['telefone'],
          'email': resultado['email'],
        });
      }
      _carregarContatos();  // Recarrega os contatos após operação
    }
  }

  final secureStorage = FlutterSecureStorage();

  Future<void> _logoff(BuildContext context) async {
    await secureStorage.delete(key: 'session');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda Telefônica'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _logoff(context),
          ),
        ],
      ),
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
                      contatos[index]['nome'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${contatos[index]['telefone']} - ${contatos[index]['email']}'),
                    onTap: () => adicionarOuEditarContato(contato: contatos[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => adicionarOuEditarContato(contato: contatos[index]),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => adicionarOuEditarContato(),
        child: Icon(Icons.add),
      ),
    );
  }
}
