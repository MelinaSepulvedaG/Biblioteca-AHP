import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultadoForm extends StatefulWidget {
  @override
  _ResultadoFormState createState() => _ResultadoFormState();
}

class _ResultadoFormState extends State<ResultadoForm> {
  //lista con los resultados para mostrar el grafico
  List<_ResultadosFinales> data = [
    _ResultadosFinales('Mazda', 28),
    _ResultadosFinales('GMC', 32),
    _ResultadosFinales('Jeep', 34),
    _ResultadosFinales('Ford', 35),
    _ResultadosFinales('RAM', 40)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Resultados'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Column(children: [
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Resultados del Algoritmo AHP'),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_ResultadosFinales, String>>[
                BarSeries<_ResultadosFinales, String>(
                    dataSource: data,
                    xValueMapper: (_ResultadosFinales datos, _) =>
                        datos.alternativas,
                    yValueMapper: (_ResultadosFinales datos, _) =>
                        datos.ponderacion,
                    name: 'Prioridades',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
        ]));
  }
}

class _ResultadosFinales {
  _ResultadosFinales(this.alternativas, this.ponderacion);

  final String alternativas;
  final double ponderacion;
}
