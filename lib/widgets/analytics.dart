import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../widgets/account_balance_text.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<StatefulWidget> createState() => AnalyticsState();
}

class AnalyticsState extends State {
  int touchedIndex = -1;
  final double _analyticsPadding = 24;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Analytics",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            PlatformTextButton(
              padding: EdgeInsets.zero,
              child: const Text(
                "See all expenses",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
            )
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(_analyticsPadding),
              child: AspectRatio(
                aspectRatio: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: double.infinity,
                            sections: showingSections(),
                            startDegreeOffset: -30,
                          ),
                          swapAnimationDuration:
                              const Duration(milliseconds: 150), // Optional
                          swapAnimationCurve: Curves.linear, // Optional
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Center(
              child: AccountBalanceText(
                value: 1234.56,
              ),
            )
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final pieChartItemRadius =
          (MediaQuery.of(context).size.width / 4.2) - _analyticsPadding;

      switch (i) {
        case 0:
          return PieChartSectionData(
            showTitle: false,
            color: const Color(0xFF272735),
            value: 60,
            radius: pieChartItemRadius,
            badgeWidget: const Icon(
              Icons.fastfood,
              color: Colors.white,
              size: 15,
            ),
          );
        case 1:
          return PieChartSectionData(
            showTitle: false,
            color: const Color(0xFF464658),
            value: 20,
            radius: pieChartItemRadius,
            badgeWidget: const Icon(
              Icons.airport_shuttle,
              color: Colors.white,
            ),
          );
        case 2:
          return PieChartSectionData(
            showTitle: false,
            color: const Color(0xFF666670),
            value: 25,
            radius: pieChartItemRadius,
            badgeWidget: const Icon(
              Icons.payments,
              color: Colors.white,
            ),
          );
        case 3:
          return PieChartSectionData(
            showTitle: false,
            color: const Color(0xFF757578),
            value: 35,
            radius: pieChartItemRadius,
            badgeWidget: const Icon(
              Icons.shopping_bag,
              color: Colors.white,
            ),
          );
        case 4:
          return PieChartSectionData(
            showTitle: false,
            color: const Color(0xFF848484),
            value: 15,
            radius: pieChartItemRadius,
            badgeWidget: const Icon(
              Icons.sports_esports,
              color: Colors.white,
            ),
          );
        case 5:
          return PieChartSectionData(
            showTitle: false,
            color: const Color(0xFF1C1A28),
            value: 35,
            radius: pieChartItemRadius,
            badgeWidget: const Icon(
              Icons.flight_takeoff,
              color: Colors.white,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
