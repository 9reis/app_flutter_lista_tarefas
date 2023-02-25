import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _todoController = TextEditingController();

  List _todoList = [];

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _todoList = json.decode(data!);
      });
    });
  }

  void _addTodo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo['title'] = _todoController.text;
      _todoController.text = "";
      newTodo['ok'] = false;
      _todoList.add(newTodo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                        labelText: "Nova tarefa",
                        labelStyle: TextStyle(
                          color: Colors.blueAccent,
                        )),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: _addTodo,
                  child: Text("ADD"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: _todoList.length,
              itemBuilder: buildItem,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    // Arrata o item para o lado p/ deletar
    return Dismissible(
      key: Key(DateTime.now()
          .millisecondsSinceEpoch
          .toString()), // Key pegando o time atual em milesse
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0), //Distancia X e Y que o item vai ficar
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction:
          DismissDirection.startToEnd, //Direção que vai dar o dismissible,
      child: CheckboxListTile(
        title: Text(_todoList[index]['title']),
        value: _todoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(
            _todoList[index]['ok'] ? Icons.check : Icons.error,
          ),
        ),
        onChanged: (bool? value) {
          setState(() {
            _todoList[index]['ok'] = value;
            _saveData();
          });
        },
      ), // Ação do dosmissible
    );
  }

  /*
  
    */

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
