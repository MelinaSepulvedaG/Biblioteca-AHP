import 'package:flutter/material.dart';
import 'comparacion_alt.dart'; // Importar la pantalla de ComparacionAlternativas

class AlternativasForm extends StatefulWidget {
  final List<String> criterios;

  final List<List<double>> matrizCriterios; // Recibimos la matriz de criterios

  AlternativasForm({
    required this.criterios,
    required this.matrizCriterios,
  });
  @override
  _AlternativasPageState createState() => _AlternativasPageState();
}

class _AlternativasPageState extends State<AlternativasForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final List<TextEditingController> _controllers = [];
  int num_campos = 0;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  void _navigateToComparacionAlternativas() {
    if (_formKey.currentState?.validate() ?? false) {
      final List<String> alternativas =
          _controllers.map((controller) => controller.text).toList();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComparacionAlternativas(
            criterios: widget.criterios,
            alternativas: alternativas,
            matrizCriterios:
                widget.matrizCriterios, // Pasar la matriz de criterios
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biblioteca MADM'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Cantidad de Alternativas',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                keyboardType: TextInputType.number,
                cursorColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    num_campos = int.tryParse(value) ?? 0;

                    if (_controllers.length < num_campos) {
                      for (int i = _controllers.length; i < num_campos; i++) {
                        _controllers.add(TextEditingController());
                      }
                    } else if (_controllers.length > num_campos) {
                      _controllers.removeRange(num_campos, _controllers.length);
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la cantidad de alternativas';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingresa un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              for (int i = 0; i < num_campos; i++)
                Column(
                  children: [
                    TextFormField(
                      controller: _controllers[i],
                      decoration: InputDecoration(
                        labelText:
                            'Ingresa el nombre de la alternativa ${i + 1}',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      cursorColor: Colors.blue,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el nombre de la alternativa ${i + 1}';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToComparacionAlternativas,
                child: Text('Siguiente'),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
