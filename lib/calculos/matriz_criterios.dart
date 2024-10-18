import 'package:flutter/material.dart';
import 'alternativas.dart'; // Importar la pantalla de AlternativasForm

class ComparacionCriterios extends StatelessWidget {
  final List<String> criterios;
  final int size;

  ComparacionCriterios({required this.criterios, required this.size});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comparación de Criterios'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: CriteriosTable(
        criterios: criterios,
        size: size,
      ),
    );
  }
}

class CriteriosTable extends StatefulWidget {
  final List<String> criterios;
  final int size;

  CriteriosTable({
    required this.criterios,
    required this.size,
  });

  @override
  _CriteriosTableState createState() => _CriteriosTableState();
}

class _CriteriosTableState extends State<CriteriosTable> {
  // Controladores para la matriz de comparación de criterios
  List<List<TextEditingController>> _matrixControllers = [];

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores de la matriz según la cantidad de criterios
    if (widget.size > 0) {
      _matrixControllers = List.generate(
        widget.size,
        (i) => List.generate(widget.size, (j) => TextEditingController()),
      );
    }
  }

  @override
  void dispose() {
    // Limpiar los controladores
    for (var row in _matrixControllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _navigateToAlternativasForm() {
    // Validar que todos los campos tengan valores
    if (_validateMatrixFields()) {
      // Obtenemos la matriz de criterios ingresada
      List<List<double>> matrizCriterios = getMatrizDeComparacionCriterios();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlternativasForm(
            criterios: widget.criterios,
            matrizCriterios:
                matrizCriterios, // Pasamos la matriz de criterios aquí
          ),
        ),
      );
    } else {
      // Mostrar un mensaje de error si hay campos vacíos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete todos los campos.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Método para validar que todos los campos tengan valores
  bool _validateMatrixFields() {
    for (int i = 0; i < widget.size; i++) {
      for (int j = 0; j < widget.size; j++) {
        if (_matrixControllers[i][j].text.isEmpty) {
          return false; // Retorna false si algún campo está vacío
        }
      }
    }
    return true; // Retorna true si todos los campos tienen valores
  }

  // Método para obtener la matriz de comparación de criterios
  List<List<double>> getMatrizDeComparacionCriterios() {
    List<List<double>> matriz = [];
    for (int i = 0; i < widget.size; i++) {
      List<double> row = [];
      for (int j = 0; j < widget.size; j++) {
        row.add(double.tryParse(_matrixControllers[i][j].text) ?? 1.0);
      }
      matriz.add(row);
    }
    return matriz;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          // Generar la tabla de criterios
          for (int i = 0; i < widget.size; i++)
            Row(
              children: <Widget>[
                for (int j = 0; j < widget.size; j++) ...[
                  Expanded(
                    child: TextFormField(
                      controller: _matrixControllers[i][j],
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey),
                        ),
                        labelText:
                            '${widget.criterios[i]} vs ${widget.criterios[j]}',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10), // Espacio entre campos de texto
                ],
              ],
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _navigateToAlternativasForm,
            child: Text('Siguiente'),
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
