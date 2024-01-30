import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talab/config/theme/app_color_constant.dart';

class ContractListItem extends StatelessWidget {
  final String name;
  final String role;
  final double amount;
  final double percentageChange;
  final double todayAmount;

  const ContractListItem({
    Key? key,
    required this.name,
    required this.role,
    required this.amount,
    required this.percentageChange,
    required this.todayAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var format = DateFormat('EEE');
    String today = format.format(now);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColorConstant.lightgrey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      role,
                      style: TextStyle(color: Colors.grey),
                    ),
                    MiniBarChart(
                      todayAmount: todayAmount,
                      today: today,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'NPR ${NumberFormat("#,##0").format(amount)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      percentageChange >= 0
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: percentageChange >= 0
                          ? AppColorConstant.blue
                          : Colors.red,
                      size: 16,
                    ),
                    Text(
                      '${percentageChange.toStringAsFixed(2)}% ( 24h ))',
                      style: TextStyle(
                          color: percentageChange >= 0
                              ? AppColorConstant.blue
                              : Colors.red,
                          fontSize: 12,
                          fontFamily: "sf-medium"),
                    ),
                  ],
                ),
                SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MiniBarChart extends StatelessWidget {
  final double todayAmount;
  final String today;

  const MiniBarChart({
    Key? key,
    required this.todayAmount,
    required this.today,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    double maxAmount = 100000;
    debugPrint('todayAmount: $today');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekdays.map((day) {
        double barHeight = todayAmount / maxAmount * 100;

        barHeight = barHeight < 20 ? 20 : barHeight;

        return Container(
          width: 8,
          height: barHeight,
          color: day == today ? Colors.black : AppColorConstant.darkgrey,
          margin: EdgeInsets.symmetric(horizontal: 2),
        );
      }).toList(),
    );
  }
}
