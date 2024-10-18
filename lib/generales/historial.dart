import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<dynamic> _historial = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    obtenerHistorial();
  }

  Future<void> obtenerHistorial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idUsuario = prefs.getString('idUsuario') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://192.168.100.15:5000/historial/$idUsuario'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _historial = responseData['historial'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Error al cargar el historial. Código: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'No se pudo conectar al servidor.';
        _isLoading = false;
      });
    }
  }

  List<String> _parseList(String? listString) {
    if (listString == null) return [];
    return listString
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(' ', '')
        .split(',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child:
                      Text(_errorMessage, style: TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.blueGrey),
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Criterios',
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Alternativas',
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Matriz',
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Resultado',
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ],
                    rows: _historial.map((item) {
                      List<String> criterios = _parseList(item['criterios']);
                      List<String> alternativas =
                          _parseList(item['alternativas']);

                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text(criterios.join(', '))),
                          DataCell(Text(alternativas.join(', '))),
                          DataCell(Text(item['matriz_completa'] ?? '')),
                          DataCell(Text(item['resultado_final'] ?? '')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
