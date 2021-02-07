import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textC = TextEditingController();
  String resultado = "";

  void resetfilds() {
    textC.text = "";
    setState(() {
      resultado = "";
    });
  }

  _consultaCep() async {
    String cep = textC.text;

    String url = "https://viacep.com.br/ws/${cep}/json/";

    http.Response response;

    response = await http.get(url);

    Map<String, dynamic> retorno = json.decode(response.body);
    String cidade = retorno["localidade"];
    String rua = retorno["logradouro"];
    String bairroInf = retorno["bairro"];

    setState(() {
      if (rua == "") {
        resultado = resultado = "Cidade: ${cidade}";
      } else {
        resultado = "Cidade: ${cidade}\nRua: ${rua}\nBairro: ${bairroInf}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Consulta CEP'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              resetfilds();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: TextField(
                controller: textC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Digite o CEP',
                    icon: Icon(Icons.add_location),
                    border: InputBorder.none),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${resultado}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                child: Text("Consultar"),
                color: Colors.blue,
                onPressed: _consultaCep,
              ),
            ),           
          ],
        ),
      ),
    );
  }
}
