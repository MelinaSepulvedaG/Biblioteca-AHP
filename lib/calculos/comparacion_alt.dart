import 'package:flutter/material.dart';
import 'resultados.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ComparacionAlternativas extends StatelessWidget {
  final List<String> criterios;
  final List<String> alternativas;
  final List<List<double>> matrizCriterios;

  ComparacionAlternativas(
      {required this.criterios,
      required this.alternativas,
      required this.matrizCriterios});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comparación de Alternativas'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ComparacionAlternativasForm(
        criterios: criterios,
        alternativas: alternativas,
      ),
    );
  }
}

class ComparacionAlternativasForm extends StatefulWidget {
  final List<String> criterios;
  final List<String> alternativas;

  ComparacionAlternativasForm({
    required this.criterios,
    required this.alternativas,
  });

  @override
  _ComparacionAlternativasFormState createState() =>
      _ComparacionAlternativasFormState();
}

class _ComparacionAlternativasFormState
    extends State<ComparacionAlternativasForm> {
  List<List<List<TextEditingController>>> _matrixControllers = [];
  late List<double> puntaje_alternativas = [];

  @override
  void initState() {
    super.initState();

    _matrixControllers = List.generate(
      widget.criterios.length,
      (c) => List.generate(
        widget.alternativas.length,
        (i) => List.generate(
            widget.alternativas.length, (j) => TextEditingController()),
      ),
    );
  }

  bool _validateMatrixFields() {
    for (int c = 0; c < widget.criterios.length; c++) {
      for (int i = 0; i < widget.alternativas.length; i++) {
        for (int j = 0; j < widget.alternativas.length; j++) {
          if (_matrixControllers[c][i][j].text.isEmpty) {
            return false;
          }
        }
      }
    }
    return true;
  }

  // Petición para el cálculo
  Future<void> _calcular() async {
    if (!_validateMatrixFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete todos los campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUsuario = prefs.getString('idUsuario');

    if (idUsuario == null) {
      print('Error: No se encontró idUsuario');
      return;
    }

    final Map<String, dynamic> requestBody = {
      'idUsuario': int.parse(idUsuario),
      'criterios': {
        'nombres': widget.criterios.map((c) => c.toString()).toList(),
        'matriz': getMatrizDeComparacionCriterios(),
        'alternativas': getMatricesDeComparacion()
      },
      'alternativas': {
        'nombres': widget.alternativas.map((a) => a.toString()).toList(),
      },
    };

    print(requestBody);
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/ahp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    print('Respuesta del servidor: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        List<String> alternativas =
            responseData['puntajes_alternativas'].keys.toList();

        List<double> puntajes = [];
        for (var value in responseData['puntajes_alternativas'].values) {
          if (value is num) {
            puntajes.add(value.toDouble());
          } else {
            puntajes.add(0.0);
          }
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultadoForm(alternativas: alternativas, puntajes: puntajes),
          ),
        );
      } catch (e) {
        print('Error al decodificar el JSON: $e');
      }
    }
  }

  List<List<double>> getMatrizDeComparacionCriterios() {
    List<List<double>> matrizCriterios = List.generate(widget.criterios.length,
        (_) => List.filled(widget.criterios.length, 1.0));

    for (int i = 0; i < widget.criterios.length; i++) {
      for (int j = 0; j < widget.criterios.length; j++) {
        if (i != j) {
          if (i < _matrixControllers.length &&
              j < _matrixControllers[i].length) {
            double valorComparacion =
                double.tryParse(_matrixControllers[i][j].toString()) ?? 1.0;

            if (valorComparacion <= 0) {
              continue;
            }

            matrizCriterios[i][j] = valorComparacion;
            matrizCriterios[j][i] =
                valorComparacion == 0 ? 1.0 : 1 / valorComparacion;
          }
        }
      }
    }

    return matrizCriterios;
  }

  List<List<List<double>>> getMatricesDeComparacion() {
    List<List<List<double>>> matrices = [];

    // generar la matriz de cada criteior
    for (int c = 0; c < widget.criterios.length; c++) {
      List<List<double>> matriz = [];

      for (int i = 0; i < widget.alternativas.length; i++) {
        List<double> row = [];

        for (int j = 0; j < widget.alternativas.length; j++) {
          row.add(double.tryParse(_matrixControllers[c][i][j].text) ?? 1.0);
        }

        matriz.add(row);
      }

      matrices.add(matriz);
    }

    return matrices;
  }

  @override
  void dispose() {
    for (var criterio in _matrixControllers) {
      for (var row in criterio) {
        for (var controller in row) {
          controller.dispose();
        }
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          for (int c = 0; c < widget.criterios.length; c++) ...[
            Text(
              'Comparación para el criterio: ${widget.criterios[c]}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            for (int i = 0; i < widget.alternativas.length; i++)
              Row(
                children: <Widget>[
                  for (int j = 0; j < widget.alternativas.length; j++) ...[
                    Expanded(
                      child: TextFormField(
                        controller: _matrixControllers[c][i][j],
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          labelText:
                              '${widget.alternativas[i]} vs ${widget.alternativas[j]}',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ],
              ),
            SizedBox(height: 30),
          ],
          ElevatedButton(
            onPressed: () {
              _calcular();
            },
            child: Text('Calcular'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Escala de Saaty',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '1: Igualmente importante\n'
                        '3: Apenas más importante\n'
                        '5: Mucho más importante\n'
                        '7: Bastante importante\n'
                        '9: Absolutamente más importante',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Cerrar',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: const Text('Escala de Saaty'),
          )
        ],
      ),
    );
  }
}
