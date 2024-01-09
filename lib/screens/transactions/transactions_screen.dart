import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_action.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_tab.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/skeleton.dart';

import '../../config.dart';
import '../../models/amount_value.dart';
import '../../models/transactions/transaction_model.dart';
import '../../models/transactions/upcoming_transaction_model.dart';
import '../../utilities/format.dart';
import '../../widgets/empty_list_message.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/transaction_listing_item.dart';
import 'transactions_filtering_screen.dart';

class TransactionsScreen extends StatefulWidget {
  static const routeName = "/transactionsScreen";

  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  ScrollController scrollController = ScrollController();
  IvoryTabController tabController = IvoryTabController(tabsCount: 2);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TransactionsViewModel>(
        onInit: (store) {
          store.dispatch(GetTransactionsCommandAction(filter: null, forceReloadTransactions: false));
        },
        converter: (store) =>
            TransactionPresenter.presentTransactions(transactionsState: store.state.transactionsState),
        builder: (context, viewModel) {
          bool isFilterActive = viewModel.transactionListFilter?.bookingDateMax != null ||
              viewModel.transactionListFilter?.bookingDateMin != null;

          return ScreenScaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                StoreProvider.of<AppState>(context).dispatch(
                  GetTransactionsCommandAction(filter: viewModel.transactionListFilter, forceReloadTransactions: true),
                );
              },
              child: Column(
                children: [
                  AppToolbar(
                    title: "Transactions",
                    scrollController: scrollController,
                    includeBottomScreenTitle: true,
                    padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                    children: [
                      CustomSearchBar(
                        hintText: "Search by name, date",
                        textLabel: viewModel.transactionListFilter?.searchString,
                        showButtonIndicator: isFilterActive,
                        onPressedFilterButton: () {
                          Navigator.pushNamed(
                            context,
                            TransactionsFilteringScreen.routeName,
                            arguments: viewModel.transactionListFilter,
                          );
                        },
                        onSubmitSearch: (value) {
                          TransactionListFilter filter;
                          if (value.isEmpty) {
                            filter = TransactionListFilter(
                              bookingDateMax: viewModel.transactionListFilter?.bookingDateMax,
                              bookingDateMin: viewModel.transactionListFilter?.bookingDateMin,
                              size: viewModel.transactionListFilter?.size,
                              categories: viewModel.transactionListFilter?.categories,
                              searchString: null,
                            );
                          } else {
                            filter = TransactionListFilter(
                              bookingDateMax: viewModel.transactionListFilter?.bookingDateMax,
                              bookingDateMin: viewModel.transactionListFilter?.bookingDateMin,
                              size: viewModel.transactionListFilter?.size,
                              categories: viewModel.transactionListFilter?.categories,
                              searchString: value,
                            );
                          }
                          StoreProvider.of<AppState>(context)
                              .dispatch(GetTransactionsCommandAction(filter: filter, forceReloadTransactions: true));
                        },
                        onChangedSearch: (String value) {
                          return;
                        },
                      ),
                      _buildFilterListDisplay(viewModel),
                      const SizedBox(height: 16),
                      IvoryTabBar(
                        controller: tabController,
                        tabs: [
                          IvoryTab(
                            title: "Past",
                            onPressed: () => StoreProvider.of<AppState>(context).dispatch(
                              GetTransactionsCommandAction(
                                filter: viewModel.transactionListFilter,
                                forceReloadTransactions: true,
                              ),
                            ),
                          ),
                          IvoryTab(
                            title: "Upcoming",
                            onPressed: () => StoreProvider.of<AppState>(context).dispatch(
                              GetUpcomingTransactionsCommandAction(
                                filter: viewModel.transactionListFilter,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: IvoryTabView(
                        controller: tabController,
                        children: [
                          _buildTransactionsList(viewModel),
                          _buildTransactionsList(viewModel),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTransactionsList(TransactionsViewModel viewModel) {
    const emptyListWidget = TextMessageWithCircularImage(
      title: "No transactions yet",
      message: "There are no transactions yet. Your future transactions will be displayed here.",
    );

    if (viewModel is TransactionsLoadingViewModel) {
      return Center(child: _buildLoadingSkeleton());
    }

    if (viewModel is TransactionsErrorViewModel) {
      return const Text("Transactions could not be loaded");
    }

    if (viewModel is TransactionsFetchedViewModel) {
      bool isFilteringActive = (viewModel.transactionListFilter?.bookingDateMin != null ||
          viewModel.transactionListFilter?.bookingDateMax != null);
      if (viewModel.transactionListFilter?.searchString != null) {
        isFilteringActive = isFilteringActive || (viewModel.transactionListFilter!.searchString!.isNotEmpty);
      }

      List<Transaction> transactions = [];

      transactions.addAll(viewModel.transactions as Iterable<Transaction>);

      if (transactions.isEmpty && !isFilteringActive) {
        return emptyListWidget;
      }

      if (transactions.isEmpty && isFilteringActive) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "No results",
              style: ClientConfig.getTextStyleScheme().heading3,
            ),
            const SizedBox(height: 16),
            Text(
              "Please apply different filters or search terms.",
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular.copyWith(color: ClientConfig.getCustomColors().neutral700),
            ),
          ],
        );
      }

      return Column(
        children: [_buildGroupedByDaysList(transactions)],
      );
    }

    if (viewModel is UpcomingTransactionsFetchedViewModel) {
      bool isFilteringActive = (viewModel.transactionListFilter?.bookingDateMin != null ||
          viewModel.transactionListFilter?.bookingDateMax != null);

      List<UpcomingTransaction> upcomingTransactions = [];

      upcomingTransactions.addAll(viewModel.upcomingTransactions as Iterable<UpcomingTransaction>);

      if (upcomingTransactions.isEmpty && !isFilteringActive) {
        return emptyListWidget;
      }

      if (upcomingTransactions.isEmpty && isFilteringActive) {
        return Text(
          "Please apply different filters and search again.",
          textAlign: TextAlign.center,
          style: ClientConfig.getTextStyleScheme().bodyLargeRegular.copyWith(color: ClientConfig.getCustomColors().neutral700),
        );
      }

      return Column(
        children: [_buildGroupedUpcomingByDaysList(upcomingTransactions)],
      );
    }

    return emptyListWidget;
  }

  String _formatDayMonthYear(String dayMonthYear) {
    var parts = dayMonthYear.split('/');
    var year = DateTime.now().year == int.parse(parts[2]) ? '' : parts[2];
    String months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][int.parse(parts[1]) - 1];

    return '$months ${parts[0]} $year';
  }

  AmountValue _sumOfDay(List<dynamic> transactions) {
    double sum = 0;

    for (var transaction in transactions) {
      sum += transaction.amount!.value!;
    }

    return AmountValue(value: sum, currency: transactions[0].amount!.currency, unit: 'cents');
  }

  String _formatAmountWithCurrency(AmountValue amount) {
    final value = amount.value;
    String currencySymbol = Format.getCurrencySymbol(amount.currency);

    String absoluteAmountValue = value.abs().toStringAsFixed(2);
    String sign = value == 0
        ? ''
        : value < 0
            ? '-'
            : '+';

    return '$sign $currencySymbol$absoluteAmountValue';
  }

  Widget _buildGroupedByDaysList(List<Transaction> transactions) {
    var groupedTransactions = <String, List<Transaction>>{};

    for (var transaction in transactions) {
      var transactionDate = DateTime.parse(transaction.bookingDate!);
      var dayMonthYear = '${transactionDate.day}/${transactionDate.month}/${transactionDate.year}';
      if (groupedTransactions.containsKey(dayMonthYear)) {
        groupedTransactions[dayMonthYear]!.add(transaction);
      } else {
        groupedTransactions[dayMonthYear] = [transaction];
      }
    }

    var dayMonthYearList = groupedTransactions.keys.toList();

    dayMonthYearList.sort((a, b) {
      var partsA = a.split('/');
      var partsB = b.split('/');
      var yearA = int.parse(partsA[2]);
      var yearB = int.parse(partsB[2]);
      var monthA = int.parse(partsA[1]);
      var monthB = int.parse(partsB[1]);
      var dayA = int.parse(partsA[0]);
      var dayB = int.parse(partsB[0]);

      if (yearA > yearB) {
        return -1;
      } else if (yearA < yearB) {
        return 1;
      } else {
        if (monthA > monthB) {
          return -1;
        } else if (monthA < monthB) {
          return 1;
        } else {
          return dayB.compareTo(dayA);
        }
      }
    });

    return ListView.separated(
      itemCount: dayMonthYearList.length,
      separatorBuilder: (context, index) => const Divider(
        height: 0,
        color: Colors.transparent,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        var dayMonthYear = dayMonthYearList[index];
        var transactions = groupedTransactions[dayMonthYear]!;
        var formattedDayMonthYear = _formatDayMonthYear(dayMonthYear);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDayMonthYear,
                    style: ClientConfig.getTextStyleScheme().labelLarge,
                  ),
                  Text(_formatAmountWithCurrency(_sumOfDay(transactions)),
                      style: ClientConfig.getTextStyleScheme().labelSmall),
                ],
              ),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: transactions.length,
              separatorBuilder: (_, __) => const Divider(
                height: 0,
                color: Colors.transparent,
              ),
              itemBuilder: (context, index) => TransactionListItem(
                transaction: transactions[index],
              ),
            ),
            const SizedBox(height: 24)
          ],
        );
      },
    );
  }

  Widget _buildGroupedUpcomingByDaysList(List<UpcomingTransaction> transactions) {
    var groupedTransactions = <String, List<UpcomingTransaction>>{};

    for (var transaction in transactions) {
      var transactionDate = DateTime.parse(transaction.dueDate.toString());
      var dayMonthYear = '${transactionDate.day}/${transactionDate.month}/${transactionDate.year}';
      if (groupedTransactions.containsKey(dayMonthYear)) {
        groupedTransactions[dayMonthYear]!.add(transaction);
      } else {
        groupedTransactions[dayMonthYear] = [transaction];
      }
    }

    var dayMonthYearList = groupedTransactions.keys.toList();

    dayMonthYearList.sort((a, b) {
      var partsA = a.split('/');
      var partsB = b.split('/');
      var yearA = int.parse(partsA[2]);
      var yearB = int.parse(partsB[2]);
      var monthA = int.parse(partsA[1]);
      var monthB = int.parse(partsB[1]);
      var dayA = int.parse(partsA[0]);
      var dayB = int.parse(partsB[0]);

      if (yearA > yearB) {
        return -1;
      } else if (yearA < yearB) {
        return 1;
      } else {
        if (monthA > monthB) {
          return -1;
        } else if (monthA < monthB) {
          return 1;
        } else {
          return dayB.compareTo(dayA);
        }
      }
    });

    AmountValue sumOfDay(List<UpcomingTransaction> transactions) {
      double sum = 0;

      for (var transaction in transactions) {
        sum += transaction.outstandingAmount!.value;
      }

      return AmountValue(value: sum, currency: transactions[0].outstandingAmount!.currency, unit: 'cents');
    }

    String formatAmountWithCurrency(AmountValue amount) {
      final value = amount.value;
      String currencySymbol = Format.getCurrencySymbol(amount.currency);

      String absoluteAmountValue = value.abs().toStringAsFixed(2);
      String sign = value == 0
          ? ''
          : value < 0
              ? '-'
              : '+';

      return '$sign $currencySymbol$absoluteAmountValue';
    }

    return ListView.separated(
      itemCount: dayMonthYearList.length,
      separatorBuilder: (context, index) => const Divider(
        height: 10,
        color: Colors.transparent,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        var dayMonthYear = dayMonthYearList[index];
        var transactions = groupedTransactions[dayMonthYear]!;
        var formattedDayMonthYear = _formatDayMonthYear(dayMonthYear);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Padding(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDayMonthYear,
                      style: ClientConfig.getTextStyleScheme().labelLarge,
                    ),
                    Text(formatAmountWithCurrency(sumOfDay(transactions)),
                        style: ClientConfig.getTextStyleScheme().labelSmall),
                  ],
                ),
              ),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: transactions.length,
              separatorBuilder: (_, __) => const Divider(
                height: 10,
                color: Colors.transparent,
              ),
              itemBuilder: (context, index) => UpcomingTransactionListItem(
                upcomingTransaction: transactions[index],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterListDisplay(TransactionsViewModel viewModel) {
    List<Widget> widgetList = [];

    if (viewModel.transactionListFilter?.bookingDateMax != null ||
        viewModel.transactionListFilter?.bookingDateMin != null) {
      widgetList.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PillButton(
              buttonText:
                  '${getFormattedDate(date: viewModel.transactionListFilter?.bookingDateMin, text: "Start date")} - ${getFormattedDate(date: viewModel.transactionListFilter?.bookingDateMax, text: "End date")}',
              buttonCallback: () {
                StoreProvider.of<AppState>(context).dispatch(GetTransactionsCommandAction(
                    filter: TransactionListFilter(
                      bookingDateMax: null,
                      bookingDateMin: null,
                      searchString: viewModel.transactionListFilter!.searchString,
                      categories: viewModel.transactionListFilter!.categories,
                    ),
                    forceReloadTransactions: true));
              },
              icon: const Icon(
                Icons.close,
                size: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (viewModel.transactionListFilter?.categories?.isNotEmpty == true) {
      for (var index = 0; index < viewModel.transactionListFilter!.categories!.length; index++) {
        widgetList.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PillButton(
                buttonText: viewModel.transactionListFilter!.categories![index].name,
                buttonCallback: () {
                  var newCategories = viewModel.transactionListFilter!.categories!;
                  newCategories.remove(viewModel.transactionListFilter!.categories![index]);
                  StoreProvider.of<AppState>(context).dispatch(GetTransactionsCommandAction(
                      filter: TransactionListFilter(
                        bookingDateMax: viewModel.transactionListFilter!.bookingDateMax,
                        bookingDateMin: viewModel.transactionListFilter!.bookingDateMax,
                        searchString: viewModel.transactionListFilter!.searchString,
                        categories: newCategories,
                      ),
                      forceReloadTransactions: true));
                },
                icon: const Icon(
                  Icons.close,
                  size: 16,
                ),
              ),
            ],
          ),
        );
      }
    }

    return Padding(
      padding: EdgeInsets.only(top: widgetList.isNotEmpty ? 16 : 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: widgetList,
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return SkeletonContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Skeleton(
                  height: 18,
                  width: 160,
                ),
                Skeleton(
                  height: 16,
                  width: 72,
                ),
              ],
            ),
            for (var i = 0; i < 6; i++) TransactionListItem.loadingSkeleton(),
          ],
        ),
      ),
    );
  }
}
