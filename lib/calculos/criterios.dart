import 'package:flutter/material.dart';
import 'matriz_criterios.dart';

class CriteriosPage extends StatefulWidget {
  @override
  _CriteriosPageState createState() => _CriteriosPageState();
}

class _CriteriosPageState extends State<CriteriosPage> {
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> _controllers = [];

  int num_campos = 0;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Cantidad de Criterios',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                keyboardType: TextInputType.number,
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
                cursorColor: Colors.blueGrey,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la cantidad de criterios';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              for (int i = 0; i < num_campos; i++)
                TextFormField(
                  controller: _controllers[i],
                  decoration: InputDecoration(
                    labelText: 'Ingresa el nombre del criterio ${i + 1}',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  cursorColor: Colors.blue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa el nombre del criterio ${i + 1}';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final List<String> criterios = _controllers
                        .map((controller) => controller.text)
                        .toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComparacionCriterios(
                          criterios: criterios,
                          size: num_campos,
                        ),
                      ),
                    );
                  }
                },
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
