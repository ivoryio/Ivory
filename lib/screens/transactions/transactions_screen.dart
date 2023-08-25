import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_action.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../models/transactions/transaction_model.dart';
import '../../models/transactions/upcoming_transaction_model.dart';
import '../../models/user.dart';
import '../../utilities/format.dart';
import '../../widgets/button.dart';
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
  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return StoreConnector<AppState, TransactionsViewModel>(
        onInit: (store) {
          store.dispatch(
              GetTransactionsCommandAction(filter: null, user: user.cognito));
        },
        converter: (store) => TransactionPresenter.presentTransactions(
            transactionsState: store.state.transactionsState),
        builder: (context, viewModel) {
          bool isFilterActive =
              viewModel.transactionListFilter?.bookingDateMax != null ||
                  viewModel.transactionListFilter?.bookingDateMin != null;

          return ScreenScaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                StoreProvider.of<AppState>(context).dispatch(
                  GetTransactionsCommandAction(
                      filter: viewModel.transactionListFilter,
                      user: user.cognito),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ClientConfig.getCustomClientUiSettings()
                      .defaultScreenHorizontalPadding,
                ),
                child: Column(
                  children: [
                    const AppToolbar(title: "Transactions"),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TransactionListTitle(
                              displayShowAllButton: false,
                            ),
                            const SizedBox(height: 16),
                            CustomSearchBar(
                              hintText: "Search by name, date",
                              textLabel:
                                  viewModel.transactionListFilter?.searchString,
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
                                    bookingDateMax: viewModel
                                        .transactionListFilter?.bookingDateMax,
                                    bookingDateMin: viewModel
                                        .transactionListFilter?.bookingDateMin,
                                    size: viewModel.transactionListFilter?.size,
                                    searchString: null,
                                  );
                                } else {
                                  filter = TransactionListFilter(
                                    bookingDateMax: viewModel
                                        .transactionListFilter?.bookingDateMax,
                                    bookingDateMin: viewModel
                                        .transactionListFilter?.bookingDateMin,
                                    size: viewModel.transactionListFilter?.size,
                                    searchString: value,
                                  );
                                }
                                StoreProvider.of<AppState>(context).dispatch(
                                    GetTransactionsCommandAction(
                                        filter: filter, user: user.cognito));
                              },
                              onChangedSearch: (String value) {
                                return;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: _buildFilterListDisplay(viewModel, user),
                            ),
                            ButtonsTransactionType(
                              user: user,
                              viewModel: viewModel,
                              buttons: [
                                ButtonTransactionTypeItem(
                                  text: TransactionTypeItems.past,
                                  child: _buildTransactionsList(viewModel),
                                ),
                                ButtonTransactionTypeItem(
                                  text: TransactionTypeItems.upcoming,
                                  child: _buildTransactionsList(viewModel),
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
            ),
          );
        });
  }

  Widget _buildTransactionsList(TransactionsViewModel viewModel) {
    const emptyListWidget = TextMessageWithCircularImage(
      title: "No transactions yet",
      message:
          "There are no transactions yet. Your future transactions will be displayed here.",
    );

    if (viewModel is TransactionsLoadingViewModel) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel is TransactionsErrorViewModel) {
      return const Text("Transactions could not be loaded");
    }

    if (viewModel is TransactionsFetchedViewModel) {
      bool isFilteringActive =
          (viewModel.transactionListFilter?.bookingDateMin != null ||
              viewModel.transactionListFilter?.bookingDateMax != null);

      List<Transaction> transactions = [];

      transactions.addAll(viewModel.transactions as Iterable<Transaction>);

      if (transactions.isEmpty && !isFilteringActive) {
        return emptyListWidget;
      }

      if (transactions.isEmpty && isFilteringActive) {
        return const Text(
          "We couldn't find any results. Please try again by searching for other transactions.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff667085),
          ),
        );
      }

      return Column(
        children: [_buildGroupedByDaysList(transactions)],
      );
    }

    if (viewModel is UpcomingTransactionsFetchedViewModel) {
      bool isFilteringActive =
          (viewModel.transactionListFilter?.bookingDateMin != null ||
              viewModel.transactionListFilter?.bookingDateMax != null);

      List<UpcomingTransaction> upcomingTransactions = [];

      upcomingTransactions.addAll(
          viewModel.upcomingTransactions as Iterable<UpcomingTransaction>);

      if (upcomingTransactions.isEmpty && !isFilteringActive) {
        return emptyListWidget;
      }

      if (upcomingTransactions.isEmpty && isFilteringActive) {
        return const Text(
          "We couldn't find any results. Please try again by searching for other transactions.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff667085),
          ),
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

  Amount _sumOfDay(List<dynamic> transactions) {
    double sum = 0;

    for (var transaction in transactions) {
      sum += transaction.amount!.value!;
    }

    return Amount(value: sum, currency: transactions[0].amount!.currency);
  }

  String _formatAmountWithCurrency(Amount amount) {
    double value = amount.value!;
    String currencySymbol = Format.getCurrencySymbol(amount.currency!);

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
      var dayMonthYear =
          '${transactionDate.day}/${transactionDate.month}/${transactionDate.year}';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDayMonthYear,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff414D63),
                  ),
                ),
                Text(_formatAmountWithCurrency(_sumOfDay(transactions)),
                    style: ClientConfig.getTextStyleScheme().labelSmall),
              ],
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

  Widget _buildGroupedUpcomingByDaysList(
      List<UpcomingTransaction> transactions) {
    var groupedTransactions = <String, List<UpcomingTransaction>>{};

    for (var transaction in transactions) {
      var transactionDate = DateTime.parse(transaction.dueDate.toString());
      var dayMonthYear =
          '${transactionDate.day}/${transactionDate.month}/${transactionDate.year}';
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

    CardBillAmount sumOfDay(List<UpcomingTransaction> transactions) {
      double sum = 0;

      for (var transaction in transactions) {
        sum += transaction.outstandingAmount!.value!;
      }

      return CardBillAmount(
          value: sum, currency: transactions[0].outstandingAmount!.currency);
    }

    String formatAmountWithCurrency(CardBillAmount amount) {
      double value = amount.value!;
      String currencySymbol = Format.getCurrencySymbol(amount.currency!);

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDayMonthYear,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff414D63),
                    ),
                  ),
                  Text(formatAmountWithCurrency(sumOfDay(transactions)),
                      style: ClientConfig.getTextStyleScheme().labelSmall),
                ],
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

  Widget _buildFilterListDisplay(TransactionsViewModel viewModel, AuthenticatedUser user) {
    List<Widget> widgetList = [];

    if(viewModel.transactionListFilter?.bookingDateMax != null ||
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
                StoreProvider.of<AppState>(context)
                    .dispatch(
                    GetTransactionsCommandAction(
                        filter: TransactionListFilter(
                          bookingDateMax: null,
                          bookingDateMin: null,
                          searchString: viewModel.transactionListFilter!.searchString,
                          categories: viewModel.transactionListFilter!.categories,
                        ),
                        user: user.cognito));
              },
              icon: const Icon(
                Icons.close,
                size: 16,
              ),
            ),
          ],
        ),);
    }

    if(viewModel.transactionListFilter?.categories?.isNotEmpty == true) {
      for(var index = 0; index < viewModel.transactionListFilter!.categories!.length; index ++) {
        widgetList.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PillButton(
                buttonText:
                viewModel.transactionListFilter!.categories![index].name,
                buttonCallback: () {
                  var newCategories = viewModel.transactionListFilter!.categories!;
                  newCategories.remove(viewModel.transactionListFilter!.categories![index]);
                  StoreProvider.of<AppState>(context)
                      .dispatch(
                      GetTransactionsCommandAction(
                          filter: TransactionListFilter(
                            bookingDateMax: viewModel.transactionListFilter!.bookingDateMax,
                            bookingDateMin: viewModel.transactionListFilter!.bookingDateMax,
                            searchString: viewModel.transactionListFilter!.searchString,
                            categories: newCategories,
                          ),
                          user: user.cognito));
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

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: widgetList,
    );
  }

}

class ButtonsTransactionType extends StatefulWidget {
  final List<ButtonTransactionTypeItem> buttons;
  final int? initialSelectedButtonIndex;
  final AuthenticatedUser user;
  final TransactionsViewModel viewModel;

  const ButtonsTransactionType({
    super.key,
    required this.buttons,
    this.initialSelectedButtonIndex,
    required this.user,
    required this.viewModel,
  });

  @override
  State<ButtonsTransactionType> createState() => _ButtonsTransactionTypeState();
}

class _ButtonsTransactionTypeState extends State<ButtonsTransactionType> {
  int selectedButton = 0;

  @override
  void initState() {
    selectedButton = widget.initialSelectedButtonIndex ?? selectedButton;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
              color: const Color(0xFFDFE2E6),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(width: 1, color: const Color(0xFFDFE2E6))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int buttonIndex = 0;
                  buttonIndex < widget.buttons.length;
                  buttonIndex++)
                ActiveButton(
                  active: selectedButton == buttonIndex,
                  type: widget.buttons[buttonIndex].text,
                  textStyle: ClientConfig.getTextStyleScheme().labelSmall,
                  onPressed: () {
                    setState(() {
                      selectedButton = buttonIndex;
                    });
                    if (buttonIndex == 0) {
                      StoreProvider.of<AppState>(context).dispatch(
                          GetTransactionsCommandAction(
                              filter: widget.viewModel.transactionListFilter,
                              user: widget.user.cognito));
                    }

                    if (buttonIndex == 1) {
                      StoreProvider.of<AppState>(context).dispatch(
                          GetUpcomingTransactionsCommandAction(
                              user: widget.user.cognito,
                              filter: widget.viewModel.transactionListFilter));
                    }
                  },
                )
            ],
          ),
        ),
        const SizedBox(height: 24),
        widget.buttons[selectedButton].child,
      ],
    );
  }
}

class ActiveButton extends StatelessWidget {
  final TransactionTypeItems type;
  final bool active;
  final Function onPressed;
  final TextStyle? textStyle;

  const ActiveButton({
    super.key,
    this.textStyle,
    required this.active,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Button(
        text: (type == TransactionTypeItems.past) ? "Past":"Upcoming",
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: active ? const Color(0xFFDFE2E6) : Colors.white,
        textColor: const Color(0xFF15141E),
        border: active
            ? Border.all(width: 1, color: const Color(0xFFDFE2E6))
            : null,
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}

class ButtonTransactionTypeItem {
  final TransactionTypeItems text;
  final Widget child;

  const ButtonTransactionTypeItem({
    required this.text,
    required this.child,
  });
}

enum TransactionTypeItems { past, upcoming }