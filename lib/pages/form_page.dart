import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  final Map<String, dynamic>? contato;

  FormPage({this.contato});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contato != null) {
      nomeController.text = widget.contato!['nome']!;
      telefoneController.text = widget.contato!['telefone']!;
      emailController.text = widget.contato!['email']!;
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  String formatarTelefone(String telefone) {
    if (telefone.length == 11) {
      return "(${telefone.substring(0, 2)}) ${telefone.substring(2, 7)}-${telefone.substring(7)}";
    }
    return telefone;
  }

  String removerMascaraTelefone(String telefone) {
    return telefone.replaceAll(RegExp(r'\D'), '');
  }

  void salvarContato() {
    if (_formKey.currentState!.validate()) {
      String telefoneFormatado = formatarTelefone(removerMascaraTelefone(telefoneController.text));
      Navigator.pop(context, {
      'nome': nomeController.text,
      'telefone': telefoneFormatado,
      'email': emailController.text,
      if (widget.contato != null) 'id': widget.contato!['id'],
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: Text(widget.contato == null ? 'Novo Contato' : 'Editar Contato')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de Nome
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.person, color: primaryColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              // Campo de Telefone
              TextFormField(
                controller: telefoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.phone, color: primaryColor),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  String telefoneSemMascara = removerMascaraTelefone(value!);
                  if (telefoneSemMascara.isEmpty || telefoneSemMascara.length != 11) {
                    return 'Telefone inválido. Use o formato: (XX) XXXXX-XXXX';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              // Campo de E-mail
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.email, color: primaryColor),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: salvarContato,
                child: Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              // Exibe o botão de excluir somente no modo de edição (quando há um contato)
              if (widget.contato != null)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, {'deletar': true});
                  },
                  child: Text('Excluir', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}