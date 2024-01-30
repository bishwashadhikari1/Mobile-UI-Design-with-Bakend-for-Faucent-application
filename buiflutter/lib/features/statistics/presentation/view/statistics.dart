import 'package:flutter/material.dart';
import 'package:talab/config/router/app_route.dart';
import 'package:talab/config/theme/app_color_constant.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// import your chosen charting package here
// Creates sample data to populate the chart
// Creates sample data to populate the chart
List<charts.Series<LinearSales, int>> _createSampleData() {
  final data = [
    LinearSales(0, 100),
    LinearSales(1, 75),
    LinearSales(2, 25),
    LinearSales(3, 100),
  ];

  return [
    charts.Series<LinearSales, int>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (LinearSales sales, _) => sales.year,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: data,
    )
  ];
}

// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class StatisticsScreen extends StatelessWidget {
  final List<charts.Series<LinearSales, int>> seriesList = _createSampleData();
  final bool animate = true;
  final List<String> names = ['shreeti', 'aayush', 'dinesh'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Statistics', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.dashboardRoute);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: kToolbarHeight +
                        40), // Height of AppBar + additional space
                Center(
                  child: Text(
                    'Total Outflow',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'NPR 10,640', // Use your formatting for the currency
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  padding: EdgeInsets.all(16),
                  child: charts.LineChart(
                    seriesList,
                    animate: animate,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.text_rotation_angledown,
                            color: AppColorConstant.blue),
                        SizedBox(width: 8),
                        Text(
                          'Your outflow decreased -7.8%\nfrom last month. Good job!',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: "sf-medium"),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 16),
                            Text(
                              'Top Contracts by Amount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            ListView.separated(
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Text('${index + 1}'),
                                  title: Text(names[index]),
                                  trailing: Text('NPR 10,345.00'),
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
