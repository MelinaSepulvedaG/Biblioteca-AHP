import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
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
    // Inicializar los controladores de la matriz de alternativas
    _matrixControllers = List.generate(
      widget.criterios.length,
      (c) => List.generate(
        widget.alternativas.length,
        (i) => List.generate(
            widget.alternativas.length, (j) => TextEditingController()),
      ),
    );
  }

  // Método para validar que todos los campos tengan valores
  bool _validateMatrixFields() {
    for (int c = 0; c < widget.criterios.length; c++) {
      for (int i = 0; i < widget.alternativas.length; i++) {
        for (int j = 0; j < widget.alternativas.length; j++) {
          if (_matrixControllers[c][i][j].text.isEmpty) {
            return false; // Retorna false si algún campo está vacío
          }
        }
      }
    }
    return true; // Retorna true si todos los campos tienen valores
  }

  // Petición para el cálculo
  Future<void> _calcular() async {
    // Validar que todos los campos tengan valores
    if (!_validateMatrixFields()) {
      // Mostrar un mensaje de error si hay campos vacíos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete todos los campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Salir si hay campos vacíos
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idUsuario = prefs.getString('idUsuario');

    if (idUsuario == null) {
      print('Error: No se encontró idUsuario');
      return;
    }

    // Aquí construimos el JSON según el formato requerido
    final Map<String, dynamic> requestBody = {
      'idUsuario':
          int.parse(idUsuario), // Asegúrate de que idUsuario sea un número
      'criterios': {
        'nombres': widget.criterios.map((c) => c.toString()).toList(),
        'matriz': getMatrizDeComparacionCriterios(),
        'alternativas': getMatricesDeComparacion()
      },
      'alternativas': {
        'nombres': widget.alternativas
            .map((a) => a.toString())
            .toList(), // Convertir a String
      },
    };

    print(requestBody); // Para ver el JSON que se enviará
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

        // Extraer alternativas y puntajes
        List<String> alternativas =
            responseData['puntajes_alternativas'].keys.toList();

        // Convertir los puntajes a una lista de double
        List<double> puntajes = [];
        for (var value in responseData['puntajes_alternativas'].values) {
          // Asegúrate de que value sea convertible a double
          if (value is num) {
            puntajes.add(value.toDouble());
          } else {
            puntajes.add(0.0); // Manejar el caso donde la conversión falle
          }
        }

        // Navegar a la página de resultados
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
          // Asegúrate de que el índice i y j sean válidos para _matrixControllers
          if (i < _matrixControllers.length &&
              j < _matrixControllers[i].length) {
            double valorComparacion =
                double.tryParse(_matrixControllers[i][j].toString()) ?? 1.0;

            if (valorComparacion <= 0) {
              // Manejar el error si es necesario
              continue;
            }

            matrizCriterios[i][j] = valorComparacion;
            matrizCriterios[j][i] =
                valorComparacion == 0 ? 1.0 : 1 / valorComparacion; // Simetría
          }
        }
      }
    }

    return matrizCriterios;
  }

  // sacar los valores de las matrices por criterio
  List<List<List<double>>> getMatricesDeComparacion() {
    List<List<List<double>>> matrices = [];

    // Iterar sobre los criterios para generar la matriz de cada uno
    for (int c = 0; c < widget.criterios.length; c++) {
      List<List<double>> matriz = [];

      // Para cada criterio, iterar sobre las alternativas (filas)
      for (int i = 0; i < widget.alternativas.length; i++) {
        List<double> row = [];

        // Iterar sobre las columnas (alternativas) de cada fila
        for (int j = 0; j < widget.alternativas.length; j++) {
          // Parsear el valor del controlador de texto a double
          row.add(double.tryParse(_matrixControllers[c][i][j].text) ?? 1.0);
        }

        // Agregar la fila a la matriz del criterio actual
        matriz.add(row);
      }

      // Agregar la matriz completa del criterio actual a la lista de matrices
      matrices.add(matriz);
    }

    return matrices;
  }

  @override
  void dispose() {
    // Limpiar los controladores
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
                  borderRadius:
                      BorderRadius.circular(16.0), // Bordes redondeados
                ),
                backgroundColor: Colors.white, // Color de fondo del diálogo
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
                          backgroundColor:
                              Colors.blue, // Color de fondo del botón
                          foregroundColor:
                              Colors.white, // Color del texto del botón
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Bordes redondeados
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
