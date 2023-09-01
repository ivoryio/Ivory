import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/infrastructure/categories/categories_presenter.dart';
import 'package:solarisdemo/redux/categories/category_action.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/checkbox.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../models/categories/category.dart';
import '../../models/transactions/transaction_model.dart';
import '../../models/user.dart';
import '../../redux/app_state.dart';
import '../../redux/transactions/transactions_action.dart';
import '../../utilities/format.dart';
import '../../widgets/modal.dart';
import '../../widgets/pill_button.dart';
import 'modals/transaction_date_picker_popup.dart';

class TransactionsFilteringScreen extends StatefulWidget {
  static const routeName = "/transactionsFilteringScreen";

  final TransactionListFilter? transactionListFilter;

  const TransactionsFilteringScreen({
    super.key,
    this.transactionListFilter,
  });

  @override
  State<TransactionsFilteringScreen> createState() =>
      _TransactionsFilteringScreenState();
}

class _TransactionsFilteringScreenState
    extends State<TransactionsFilteringScreen> {
  TransactionListFilter? transactionListFilter;

  @override
  void initState() {
    transactionListFilter = widget.transactionListFilter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFilterSelected = transactionListFilter?.bookingDateMin != null ||
        transactionListFilter?.bookingDateMax != null;

    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return ScreenScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ClientConfig.getCustomClientUiSettings()
              .defaultScreenHorizontalPadding,
        ),
        child: Column(
          children: [
            AppToolbar(
              onBackButtonPressed: () {
                transactionListFilter = widget.transactionListFilter;
                Navigator.of(context).pop();
              },
              richTextTitle: RichText(
                text: TextSpan(
                  text: "Filter",
                  style: ClientConfig.getTextStyleScheme().heading4,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "By date",
                      style: ClientConfig.getTextStyleScheme().labelLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.today,
                          size: 24,
                          color: ClientConfig.getColorScheme().secondary,
                        ),
                        PillButton(
                          active:
                              transactionListFilter?.bookingDateMin != null ||
                                  transactionListFilter?.bookingDateMax != null,
                          buttonText:
                              '${getFormattedDate(date: transactionListFilter?.bookingDateMin, text: "Start date")} - ${getFormattedDate(date: transactionListFilter?.bookingDateMax, text: "End date")}',
                          buttonCallback: () {
                            showBottomModal(
                              context: context,
                              showCloseButton: false,
                              content: TransactionDatePickerPopup(
                                initialSelectedRange: isFilterSelected
                                    ? DateTimeRange(
                                        start: transactionListFilter!
                                            .bookingDateMin!,
                                        end: transactionListFilter!
                                            .bookingDateMax!)
                                    : null,
                                onDateRangeSelected: (DateTimeRange range) {
                                  setState(() {
                                    transactionListFilter =
                                        TransactionListFilter(
                                      bookingDateMin: range.start,
                                      bookingDateMax: range.end,
                                    );
                                  });
                                },
                              ),
                            );
                          },
                          icon: (transactionListFilter?.bookingDateMin !=
                                      null ||
                                  transactionListFilter?.bookingDateMax != null)
                              ? const Icon(
                                  Icons.close,
                                  size: 16,
                                )
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Text(
                      "By category",
                      style: ClientConfig.getTextStyleScheme().labelLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    StoreConnector<AppState, CategoriesViewModel>(
                      onInit: (store) {
                        store.dispatch(
                            GetCategoriesCommandAction(user: user.cognito));
                      },
                      converter: (store) =>
                          CategoriesPresenter.presentCategories(
                              categoriesState: store.state.categoriesState),
                      builder: (context, viewModel) {
                        return Column(
                          children: _buildFiltersListList(
                              viewModel, transactionListFilter,
                              (category, selected) {
                            final List<Category> categories =
                                transactionListFilter?.categories ?? [];
                            if (selected == true) {
                              categories.add(category);
                            } else {
                              categories.remove(category);
                            }
                            setState(() {
                              transactionListFilter = TransactionListFilter(
                                bookingDateMin:
                                    transactionListFilter?.bookingDateMin,
                                bookingDateMax:
                                    transactionListFilter?.bookingDateMax,
                                searchString:
                                    transactionListFilter?.searchString,
                                categories: categories,
                              );
                            });
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    return ClientConfig.getColorScheme().tertiary;
                  }),
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)))),
                ),
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(
                      GetTransactionsCommandAction(
                          filter: transactionListFilter, user: user.cognito));

                  Navigator.pop(context);
                },
                child: Text(
                  "Apply filters",
                  style: ClientConfig.getTextStyleScheme()
                      .bodyLargeRegularBold
                      .copyWith(color: ClientConfig.getColorScheme().surface),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

String getFormattedDate({
  DateTime? date,
  String text = "Date not set",
}) {
  if (date == null) {
    return text;
  }

  return Format.date(date, pattern: "dd MMM yyyy");
}

List<Widget> _buildFiltersListList(
    CategoriesViewModel viewModel,
    TransactionListFilter? filter,
    final Function(Category, bool) onSelectionChanged) {
  final List<Widget> widgetsList = [];

  if (viewModel is CategoriesErrorViewModel) {
    return [
      const Center(
          child:
              Text("An error appeared while getting the available categories"))
    ];
  }

  if (viewModel is WithCategoriesViewModel) {
    for (int index = 0; index < viewModel.categories!.length; index++) {
      final Category category = viewModel.categories![index];
      widgetsList.add(_CategoryRow(
        category: category,
        filter: filter,
        onSelectionChanged: onSelectionChanged,
      ));
      widgetsList.add(const SizedBox(
        height: 24,
      ));
    }

    return widgetsList;
  }

  return [const Center(child: CircularProgressIndicator())];
}

class _CategoryRow extends StatefulWidget {
  final Category category;
  final TransactionListFilter? filter;
  final Function(Category, bool) onSelectionChanged;

  const _CategoryRow(
      {Key? key,
      required this.category,
      required this.filter,
      required this.onSelectionChanged})
      : super(key: key);

  @override
  State<_CategoryRow> createState() => _CategoryRowState();
}

class _CategoryRowState extends State<_CategoryRow> {
  late bool isSelected;

  @override
  void initState() {
    isSelected = (widget.filter?.categories == null)
        ? false
        : (widget.filter!.categories!.contains(widget.category));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CheckboxWidget(
            isChecked: isSelected,
            onChanged: (bool? value) {
              widget.onSelectionChanged(widget.category, value!);
            }),
        const SizedBox(
          width: 8,
        ),
        Text(
          widget.category.name,
          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
        ),
      ],
    );
  }
}
