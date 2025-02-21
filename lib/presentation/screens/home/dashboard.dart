import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('UTAH PAINTING', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://cdn0.iconfinder.com/data/icons/man-avatars-flat-icon-1/128/Man_11-512.png'), // URL de la imagen del perfil
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Métricas principales
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetricCard('Total Tareas', '120', const Color.fromARGB(255, 87, 148, 6)),
                  _buildMetricCard('Completadas', '40', Colors.greenAccent),
                  _buildMetricCard('En Progreso', '40', Colors.orangeAccent),
                  _buildMetricCard('Por Hacer', '40', Colors.blue),
                ],
              ),
              SizedBox(height: 16),
              // Gráfico de pastel
              _buildCard('Estado de Tareas', _buildPieChart(context)),
              SizedBox(height: 16),
              // Gráfico de barras para tareas por usuario asignado
              _buildCard('Tareas por Usuario Asignado', _buildUserTasksChart()),
              SizedBox(height: 16),
              // Card para tareas por hacer
              _buildCard('Tareas por Hacer', _buildTasksToDoChart()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        color: color.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 8),
              Text(value, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    var data = [
      PieChartSectionData(
        value: 40,
        color: Colors.blue,
        title: 'Por Hacer',
        titlePositionPercentageOffset: 1.2,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        value: 40,
        color: Colors.orange,
        title: 'En Progreso',
        titlePositionPercentageOffset: 1.2,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        value: 30,
        color: Colors.green,
        title: 'Completadas',
        titlePositionPercentageOffset: 1.2,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ];

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: data,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                return;
              }
              final touchedSection = pieTouchResponse.touchedSection!;
              final value = touchedSection.touchedSection!.value;
              final title = touchedSection.touchedSection!.title;
              final color = touchedSection.touchedSection!.color;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sección: $title, Valor: $value'),
                  backgroundColor: color,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserTasksChart() {
    var data = [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(fromY: 0, toY: 8, color: Colors.purple),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(fromY: 0, toY: 12, color: Colors.teal),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(fromY: 0, toY: 5, color: Colors.amber),
        ],
      ),
    ];

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: data,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  Widget text;
                  switch (value.toInt()) {
                    case 0:
                      text = Text('Alice', style: style);
                      break;
                    case 1:
                      text = Text('Bob', style: style);
                      break;
                    case 2:
                      text = Text('Charlie', style: style);
                      break;
                    default:
                      text = Text('', style: style);
                      break;
                  }
                  return SideTitleWidget(
                    space: 4.0,
                    child: text,
                    meta: meta,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTasksToDoChart() {
    var data = [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(fromY: 0, toY: 10, color: Colors.red),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(fromY: 0, toY: 15, color: Colors.blue),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(fromY: 0, toY: 20, color: Colors.green),
        ],
      ),
    ];

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: data,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  Widget text;
                  switch (value.toInt()) {
                    case 0:
                      text = Text('Task 1', style: style);
                      break;
                    case 1:
                      text = Text('Task 2', style: style);
                      break;
                    case 2:
                      text = Text('Task 3', style: style);
                      break;
                    default:
                      text = Text('', style: style);
                      break;
                  }
                  return SideTitleWidget(
                    space: 4.0,
                    child: text,
                    meta: meta,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}