import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _todoList = [];

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Future<File> _getFile() async {
    final directory =
        await getApplicationDocumentsDirectory(); //Pega o arq que irá SALVAR os dados
    return File("${directory.path}/data.json"); //Abre o arq
  }

  //Ler e salvar arq tem que ser async
  //SALVA os dados
  Future<File> _saveData() async {
    String data = json.encode(_todoList); // Lista TO json
    final file = await _getFile(); //Pega o arq
    return file.writeAsString(data); //Escreve/Salva os dados no arq
  }

  Future<String?> _readData() async {
    try {
      final file = await _getFile(); //Pega o arq
      return file.readAsString(); // Lê o arq
    } catch (e) {
      return null;
    }
  }
}
