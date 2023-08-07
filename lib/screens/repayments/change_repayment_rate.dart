import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/config.dart';

import '../../router/routing_constants.dart';
import '../../widgets/button.dart';
import '../../widgets/modal.dart';
import '../../widgets/screen.dart';

class ChangeRepaymentRateScreen extends StatelessWidget {
  const ChangeRepaymentRateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      backButtonIcon: const Icon(Icons.arrow_back, size: 24),
      customBackButtonCallback: () {
        context.push(repaymentsRoute.path);
      },
      centerTitle: true,
      hideAppBar: false,
      hideBackButton: false,
      hideBottomNavbar: true,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                ClientConfig.getCustomClientUiSettings()
                    .defaultScreenVerticalPadding,
                ClientConfig.getCustomClientUiSettings()
                    .defaultScreenVerticalPadding,
                ClientConfig.getCustomClientUiSettings()
                    .defaultScreenVerticalPadding,
                8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Change repayment rate',
                            style: ClientConfig.getTextStyleScheme().heading1,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'You can decide whether you prefer the flexibility of a percentage rate repayment or the predictability of fixed repayments.',
                            style: ClientConfig.getTextStyleScheme()
                                .bodyLargeRegular,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const ChooseRepaymentType(),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: PrimaryButton(
                      text: "Save changes",
                      disabledColor: const Color(0xFFDFE2E6),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
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
}

class ChooseRepaymentType extends StatefulWidget {
  const ChooseRepaymentType({super.key});

  @override
  State<ChooseRepaymentType> createState() => _ChooseRepaymentTypeState();
}

class _ChooseRepaymentTypeState extends State<ChooseRepaymentType> {
  RepaymentType _selectedOption = RepaymentType.percentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRepaymentOption(type: RepaymentType.percentage),
        const SizedBox(height: 16),
        _buildRepaymentOption(type: RepaymentType.fixed),
      ],
    );
  }

  Widget _buildRepaymentOption({required RepaymentType type}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            width: 1,
            color: _selectedOption == type
                ? const Color(0xFF2575FC)
                : const Color(0xFFE9EAEB),
            style: BorderStyle.solid,
          ),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                activeColor: const Color(0xFF2575FC),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity,
                ),
                value: type,
                groupValue: _selectedOption,
                onChanged: (RepaymentType? value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  type == RepaymentType.percentage
                      ? 'Percentage rate repayment'
                      : 'Fixed repayment',
                  style: ClientConfig.getTextStyleScheme().labelMedium,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                child: SvgPicture.asset(
                  "assets/icons/info.svg",
                  width: 24,
                  height: 24,
                ),
                onTap: () {
                  final titleOfModal = type == RepaymentType.percentage
                      ? 'Percentage rate repayment'
                      : 'Fixed rate repayment';
                  final messageOfModal = type == RepaymentType.percentage
                      ? 'Reflects the overall cost of repaying credit, accounting for interest and fees. It allows for transparency and informed financial decisions.'
                      : 'Ensures stability by keeping the interest rate constant throughout the loan term. It provides predictability.';
                  showBottomModal(
                    context: context,
                    title: titleOfModal,
                    message: messageOfModal,
                  );
                },
              ),
            ],
          ),
          if (type == RepaymentType.percentage)
            Row(
              children: [Text("percentage rate repayment")],
            ),
          if (type == RepaymentType.fixed)
            Row(
              children: [Text("fixed rate repayment")],
            ),
        ],
      ),
    );
  }
}

enum RepaymentType {
  percentage,
  fixed,
}
