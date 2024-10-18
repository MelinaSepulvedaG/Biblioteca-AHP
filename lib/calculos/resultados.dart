import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'comparacion_alt.dart';

class ResultadoForm extends StatefulWidget {
  final List<String> alternativas;
  final List<double> puntajes;

  ResultadoForm({required this.alternativas, required this.puntajes});

  @override
  _ResultadoFormState createState() => _ResultadoFormState();
}

class _ResultadoFormState extends State<ResultadoForm> {
  late List<_ResultadosFinales> data;
  @override
  void initState() {
    super.initState();
    // Ordenar los datos de mayor a menor basados en las ponderaciones
    widget.puntajes.sort((a, b) => a.compareTo(b));

    // Inicializar 'data' utilizando las listas pasadas por el widget
    data = List<_ResultadosFinales>.generate(
        widget.alternativas.length,
        (index) => _ResultadosFinales(
            widget.alternativas[index], widget.puntajes[index]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Resultados del Algoritmo AHP'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<_ResultadosFinales, String>>[
              BarSeries<_ResultadosFinales, String>(
                dataSource: data,
                xValueMapper: (_ResultadosFinales datos, _) =>
                    datos.alternativa,
                yValueMapper: (_ResultadosFinales datos, _) =>
                    datos.ponderacion,
                name: 'Prioridades',
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Ir al inicio'),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white)),
        ],
      ),
    );
  }
}

class _ResultadosFinales {
  _ResultadosFinales(this.alternativa, this.ponderacion);

  final String alternativa;
  final double ponderacion;
}
