import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../utilities/format.dart';

class BankCardShowDetailsWidget extends StatelessWidget {
  final String cardNumber;
  final String cardExpiry;
  final String? cardCvv;
  final String? cardType;
  final String? backgroundImageFile;

  const BankCardShowDetailsWidget(
      {super.key,
      required this.cardNumber,
      required this.cardExpiry,
      this.cardCvv,
      this.cardType,
      this.backgroundImageFile});

  @override
  Widget build(BuildContext context) {
    // List<String> cardNumberParts = Format.iban(cardNumber).split(" ");

    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 295 / 188,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0.0, 0.5629],
                colors: [
                  Color(0xFF585858),
                  Color(0xFF000000),
                ],
                transform: GradientRotation(135 * (3.1415926 / 180.0)),
              ),
              image: (backgroundImageFile != null)
                  ? DecorationImage(
                      image: AssetImage('assets/images/$backgroundImageFile'),
                      fit: BoxFit.scaleDown,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: VisaSvgIcon(),
                          ),
                        ],
                      ),
                      if (cardType != null) CardTypeLabel(cardType: cardType!),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "CARD HOLDER",
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 16 / 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  cardNumber,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    height: 32 / 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Row(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VisaSvgIcon extends StatelessWidget {
  const VisaSvgIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icons/visa_pay_logo.svg",
      width: 40,
      height: 40,
      placeholderBuilder: (context) => const Text("VISA"),
    );
  }
}

class EyeIcon extends StatelessWidget {
  const EyeIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 20),
      child: Icon(
        Icons.remove_red_eye_outlined,
        color: Colors.white,
        size: 25,
      ),
    );
  }
}

class CardTypeLabel extends StatelessWidget {
  final String cardType;

  const CardTypeLabel({
    super.key,
    required this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(1000),
          bottomLeft: Radius.circular(1000),
        ),
      ),
      child: Text(
        cardType,
        style: const TextStyle(
          fontSize: 12,
          height: 18 / 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
