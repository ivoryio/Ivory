import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../router/routing_constants.dart';
import '../../../widgets/button.dart';
import '../../../widgets/spaced_column.dart';
import '../../transfer/transfer_screen.dart';

class NewTransferPopup extends StatefulWidget {
  const NewTransferPopup({Key? key}) : super(key: key);

  @override
  NewTransferPopupState createState() => NewTransferPopupState();
}

class NewTransferPopupState extends State<NewTransferPopup> {
  bool _isPersonSelected = true;
  bool _isBusinessSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Who are you sending to?",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SpacedColumn(
          space: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BorderedContainer(
              onTap: () {
                setState(() {
                  _isPersonSelected = true;
                  _isBusinessSelected = false;
                });
              },
              borderColor:
                  _isPersonSelected ? Colors.black : const Color(0xFFEAECF0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 11.3),
                      Text(
                        "Person",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [RadioButton(checked: _isPersonSelected)],
                  ),
                ],
              ),
            ),
            BorderedContainer(
              onTap: () {
                setState(() {
                  _isBusinessSelected = true;
                  _isPersonSelected = false;
                });
              },
              borderColor:
                  _isBusinessSelected ? Colors.black : const Color(0xFFEAECF0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.work),
                      SizedBox(width: 10),
                      Text(
                        "Business/Organization",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  RadioButton(
                    checked: _isBusinessSelected,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: PrimaryButton(
            text: "Continue",
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              context.push(
                transferRoute.path,
                extra: TransferScreenParams(
                    transferType: _isPersonSelected
                        ? TransferType.person
                        : TransferType.business),
              );
            },
          ),
        ),
      ],
    );
  }
}

class BorderedContainer extends StatelessWidget {
  final Color borderColor;
  final Function? onTap;
  final Widget child;
  final EdgeInsets? customPadding;
  final double? customHeight;

  const BorderedContainer({
    super.key,
    this.onTap,
    this.borderColor = Colors.black,
    this.customPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.customHeight = 68,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap!() : null,
      child: Container(
        height: customHeight,
        padding: customPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: child,
      ),
    );
  }
}

class RadioButton extends StatelessWidget {
  final bool checked;

  final Function? onTap;

  const RadioButton({
    super.key,
    this.checked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap!() : null,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: checked ? Colors.black : null,
          border: Border.all(
            color: const Color(0xFFEAECF0),
          ),
        ),
        child: Icon(
          checked ? Icons.check : Icons.radio_button_unchecked,
          color: Colors.white,
          size: 10,
        ),
      ),
    );
  }
}
