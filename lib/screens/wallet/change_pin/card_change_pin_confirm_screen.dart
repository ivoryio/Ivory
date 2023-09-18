import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/screens/wallet/change_pin/card_change_pin_success_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class BankCardConfirmPinConfirmScreen extends StatelessWidget {
  static const routeName = "/bankCardChangePinConfirmScreen";

  const BankCardConfirmPinConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!;
    ValueNotifier<bool> matchingPinErrorNotifier = ValueNotifier<bool>(false);

    return StoreConnector<AppState, BankCardViewModel>(
      onDidChange: (previousViewModel, viewModel) {
        if (previousViewModel is BankCardLoadingViewModel && viewModel is BankCardPinConfirmedViewModel) {
          Navigator.of(context).pushNamed(
            BankCardChangePinSuccessScreen.routeName,
          );
        }
      },
      converter: (store) {
        return BankCardPresenter.presentBankCard(
          bankCardState: store.state.bankCardState,
          user: user,
        );
      },
      builder: (context, viewModel) {
        if (viewModel is BankCardLoadingViewModel) {
          return const ScreenScaffold(
            body: Column(
              children: [
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          );
        }
        return ScreenScaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AppToolbar(
                  onBackButtonPressed: () {
                    Navigator.pop(context);
                    StoreProvider.of<AppState>(context).dispatch(
                      GetBankCardCommandAction(
                        user: user,
                        cardId: viewModel.bankCard!.id,
                      ),
                    );
                  },
                  richTextTitle: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Step 2',
                          style: ClientConfig.getTextStyleScheme().heading4,
                        ),
                        TextSpan(
                          text: " out of 2",
                          style: ClientConfig.getTextStyleScheme().heading4.copyWith(color: const Color(0xFF56555E)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(
                  value: 0.5,
                  color: ClientConfig.getColorScheme().secondary,
                  backgroundColor: const Color(0xFFADADB4),
                ),
              ),
              ConfirmPinBody(
                viewModel: viewModel,
                matchingPinErrorNotifier: matchingPinErrorNotifier,
              ),
              const Spacer(),
              if (viewModel is! BankCardPinConfirmedViewModel)
                ConfirmPinChecks(
                  matchingPinErrorNotifier: matchingPinErrorNotifier,
                ),
            ],
          ),
        );
      },
    );
  }
}

class ConfirmPinBody extends StatefulWidget {
  BankCardViewModel viewModel;
  final ValueNotifier<bool> matchingPinErrorNotifier;
  ConfirmPinBody({
    Key? key,
    required this.viewModel,
    required this.matchingPinErrorNotifier,
  }) : super(key: key);

  @override
  State<ConfirmPinBody> createState() => _ConfirmPinBodyState();
}

class _ConfirmPinBodyState extends State<ConfirmPinBody> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusPin = FocusNode();
  String _newPIN = '';
  bool hasError = false;

  bool isPinMatching(String oldPIN, String newPIN) {
    if (newPIN.length != 4) {
      widget.matchingPinErrorNotifier.value = false;
      return true;
    }
    if (newPIN == oldPIN) {
      widget.matchingPinErrorNotifier.value = false;
      return true;
    } else {
      widget.matchingPinErrorNotifier.value = true;
      return false;
    }
  }

  void resetErrorNotifiers() {
    hasError = false;
    widget.matchingPinErrorNotifier.value = false;
  }

  void clearPinAndResetFocus() {
    _newPIN = '';
    _controller.clear();
    _focusPin.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Confirm PIN",
            style: ClientConfig.getTextStyleScheme().heading2,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "Confirm your PIN by typing it again.",
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
          ),
          const SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () {
              _focusPin.requestFocus();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) {
                  return Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: hasError
                          ? const Color(0xffE61F27)
                          : widget.viewModel is BankCardPinConfirmedViewModel
                              ? const Color(0xff00774C)
                              : index >= _newPIN.length
                                  ? const Color(0xffadadb4)
                                  : const Color(0xff15141E),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 1,
            child: TextField(
              autofocus: true,
              controller: _controller,
              focusNode: _focusPin,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration.collapsed(
                hintText: 'PIN',
              ),
              style: TextStyle(
                color: Colors.grey.withOpacity(0),
              ),
              cursorColor: Colors.transparent,
              cursorRadius: const Radius.circular(0),
              cursorWidth: 0,
              onChanged: (text) {
                if (text.length <= 4) {
                  setState(
                    () {
                      _newPIN = text;
                      hasError = !isPinMatching(widget.viewModel.pin!, _newPIN);
                      if (hasError && text.length == 4) {
                        Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            setState(
                              () {
                                resetErrorNotifiers();
                                clearPinAndResetFocus();
                              },
                            );
                          },
                        );
                      } else if (!hasError && text.length == 4) {
                        _focusPin.unfocus();
                        StoreProvider.of<AppState>(context).dispatch(
                          BankCardConfirmPinCommandAction(
                            pin: _newPIN,
                            user: user,
                            bankCard: widget.viewModel.bankCard!,
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmPinChecks extends StatelessWidget {
  final ValueNotifier<bool> matchingPinErrorNotifier;

  const ConfirmPinChecks({
    Key? key,
    required this.matchingPinErrorNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<bool>(
              valueListenable: matchingPinErrorNotifier,
              builder: (context, hasError, child) {
                return Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 24,
                      color: matchingPinErrorNotifier.value ? const Color(0xffE61F27) : const Color(0xFF56555E),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Your PIN should match",
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular.copyWith(
                          color: matchingPinErrorNotifier.value ? const Color(0xffE61F27) : const Color(0xFF56555E)),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
