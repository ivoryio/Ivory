import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<StatefulWidget> createState() => AnalyticsState();
}

class AnalyticsState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: Column(
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
          Padding(
            padding: const EdgeInsets.all(24),
            child: AspectRatio(
              aspectRatio: 1,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: double.infinity,
                          sections: showingSections(),
                          startDegreeOffset: -30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final radius = (MediaQuery.of(context).size.width / 4.2) - 24;
      switch (i) {
        case 0:
          return PieChartSectionData(
            showTitle: false,
            color: const Color(0xFF272735),
            value: 60,
            radius: radius,
            badgeWidget: const Icon(
              Icons.fastfood,
              color: Colors.white,
            ),
          );
        case 1:
          return PieChartSectionData(
            showTitle: false,
            color: const Color(0xFF464658),
            value: 20,
            radius: radius,
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
            radius: radius,
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
            radius: radius,
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
            radius: radius,
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
            radius: radius,
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
