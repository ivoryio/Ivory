import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_presenter.dart';
import 'package:solarisdemo/widgets/account_balance_text.dart';

import '../config.dart';
import '../models/transactions/transaction_model.dart';
import '../redux/app_state.dart';

class Analytics extends StatefulWidget {
  final List<Transaction> transactions;

  const Analytics({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AnalyticsState();
}

class AnalyticsState extends State<Analytics> {
  int touchedIndex = -1;
  final double _analyticsPadding = 24;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TransactionsViewModel>(
      converter: (store) => TransactionPresenter.presentTransactions(
          transactionsState: store.state.transactionsState),
      builder: (context, viewModel) {
        Widget emptyListWidget = Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Spending analytics",
                  style: ClientConfig.getTextStyleScheme().labelLarge,
                ),
                PlatformTextButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    "See all expenses",
                    textAlign: TextAlign.right,
                    style:ClientConfig.getTextStyleScheme().labelMedium.copyWith(color:ClientConfig.getColorScheme().secondary,),
                  ),
                  onPressed: () {},
                )
              ],
            ),
            Text(
              "No analytics available. Start spending and you will see your analytics displayed here.",
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular.copyWith(color: const Color(0xFF56555E)),
            ),
          ],
        );

        switch (viewModel.runtimeType) {
          case TransactionsInitialViewModel:
            return emptyListWidget;
          case TransactionsLoadingViewModel:
            return const Center(child: CircularProgressIndicator());
          case TransactionsErrorViewModel:
            return const Text("Transactions could not be loaded");
          case TransactionsFetchedViewModel:
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Spending analytics",
                      style: ClientConfig.getTextStyleScheme().labelLarge,
                    ),
                    PlatformTextButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        "See all expenses",
                        textAlign: TextAlign.right,
                        style: ClientConfig.getTextStyleScheme().labelMedium.copyWith(color:ClientConfig.getColorScheme().secondary,),
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
                widget.transactions.isNotEmpty
                    ? Stack(
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
                                        swapAnimationDuration: const Duration(
                                            milliseconds: 150), // Optional
                                        swapAnimationCurve:
                                            Curves.linear, // Optional
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: AccountBalanceText(
                              value: 2481.13,
                            ),
                          )
                        ],
                      )
                    : Text(
                        "No analytics available. Start spending and you will see your analytics displayed here.",
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegular.copyWith(color: const Color(0xFF56555E)),
                      ),
              ],
            );

          default:
            return const Text("Transactions could not be loaded");
        }
      },
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
