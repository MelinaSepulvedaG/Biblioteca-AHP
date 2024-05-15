import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/resultados.dart';

class CalculosForm extends StatefulWidget {
  @override
  _CalculosFormState createState() => _CalculosFormState();
}

class _CalculosFormState extends State<CalculosForm> {
  int num_campos = 0;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
              decoration: const InputDecoration(
                labelText: 'Cantidad de Criterios',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  num_campos = int.tryParse(value) ?? 0;
                });
              },
              cursorColor: Colors.blue,
              validator: (value) {
                if (value == "") {
                  return 'Por favor ingresa la cantidad de criterios';
                }
                return null;
              }),
          SizedBox(
            height: 40,
          ),
          for (int i = 1; i <= num_campos; i++)
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Ingresa el nombre del criterio $i',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  )),
              cursorColor: Colors.blue,
            ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                print('Calculo realizado exitosamente');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlternativasPage()),
                );
              },
              child: Text('Siguiente'),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white)),
        ],
      ),
    );
  }
}

//PAGE ALTERNATIVAS

class AlternativasForm extends StatefulWidget {
  @override
  _AlternativasFormState createState() => _AlternativasFormState();
}

class _AlternativasFormState extends State<AlternativasForm> {
  int num_campos = 0;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
              decoration: InputDecoration(
                  labelText: 'Cantidad de Alternativas',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  )),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  num_campos = int.tryParse(value) ?? 0;
                });
              },
              cursorColor: Colors.blue,
              validator: (value) {
                if (value == "") {
                  return 'Por favor ingresa la cantidad de alternativas';
                }
                return null;
              }),
          SizedBox(
            height: 40,
          ),
          for (int i = 1; i <= num_campos; i++)
            TextFormField(
                decoration: InputDecoration(
                    labelText: 'Ingresa el nombre de la alternativa $i',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    )),
                cursorColor: Colors.blue,
                validator: (value) {
                  if (value == "") {
                    return 'Por favor ingresa el nombre de la alternativa';
                  }
                  return null;
                }),
          ElevatedButton(
              onPressed: () {
                print('Calculo realizado exitosamente');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MatrizComparacionPage()),
                );
              },
              child: Text('Siguiente'),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white)),
        ],
      ),
    );
  }
}

//PAGE MATRIZ
class MatrizComparacionForm extends StatefulWidget {
  @override
  _MatrizComparacionFormState createState() => _MatrizComparacionFormState();
}

//ResultadosPage objResultado = new ResultadosPage();

class _MatrizComparacionFormState extends State<MatrizComparacionForm> {
  int num_row = 0;
  int num_headers = 0;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Table(
                border: TableBorder.all(
                  color: Colors.blue,
                ), // Allows to add a border decoration around your table

                children: [
                  TableRow(children: [
                    Text(''),
                    Text(''),
                    Text(''),
                  ]),
                  TableRow(children: [
                    Text(
                      '',
                    ),
                    Text(''),
                    Text(''),
                  ]),
                  TableRow(children: [
                    Text(''),
                    Text(''),
                    Text(''),
                  ]),
                ]),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  print('Calculo realizado exitosamente');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultadoForm()),
                  );
                },
                child: Text('Calcular'),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white)),
          ]),
    );
  }
}
