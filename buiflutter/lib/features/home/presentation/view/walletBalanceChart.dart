import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class WalletBalanceChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  WalletBalanceChart(this.seriesList, {this.animate = false});

  factory WalletBalanceChart.withSampleData() {
    return WalletBalanceChart(
      _createSampleData(),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      defaultRenderer: charts.BarRendererConfig(
        // You can adjust the strokeWidth to change the width of the bars.
        strokeWidthPx: 2.0,
      ),
      domainAxis: const charts.OrdinalAxisSpec(),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 5, // Example for more granularity
        ),
      ),
    );
  }

  static List<charts.Series<WalletBalance, String>> _createSampleData() {
    final data = [
      new WalletBalance('M', 500),
      new WalletBalance('T', 10000),
      new WalletBalance('W', 10000),
      new WalletBalance('T', 7500),
      new WalletBalance('F', 5050),
      new WalletBalance('S', 10000),
    ];

    return [
      new charts.Series<WalletBalance, String>(
        id: 'Balance',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (WalletBalance balance, _) => balance.day,
        measureFn: (WalletBalance balance, _) => balance.value,
        data: data,
      )
    ];
  }
}

class WalletBalance {
  final String day;
  final double value;

  WalletBalance(this.day, this.value);
}
