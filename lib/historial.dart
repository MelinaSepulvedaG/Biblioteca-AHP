import 'package:flutter/material.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
        border: TableBorder.all(
          color: Colors.blue,
        ), // Allows to add a border decoration around your table
        children: [
          TableRow(children: [
            Text(''),
            Text('Costo'),
            Text('Seguridad'),
            Text('Confort'),
            Text('Prioridad')
          ]),
          TableRow(children: [
            Text(
              'Mazda',
            ),
            Text('0.333'),
            Text('2'),
            Text('5'),
            Text('0.29')
          ]),
          TableRow(children: [
            Text('Ford'),
            Text('0.2814'),
            Text('0.111'),
            Text('7'),
            Text('0.57')
          ]),
        ]);
  }
}
