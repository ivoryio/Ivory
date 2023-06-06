import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'spaced_column.dart';
import '../utilities/format.dart';

const double defaultCardHorizontalPadding = 20;
const double defaultCardVerticalPadding = 15;

class DebitCardWidget extends StatelessWidget {
  final bool isPrimary;
  final String cardHolder;
  final String cardNumber;
  final String cardExpiry;
  final bool? isViewable;

  const DebitCardWidget({
    super.key,
    this.isPrimary = false,
    required this.cardExpiry,
    required this.cardHolder,
    required this.cardNumber,
    this.isViewable = true,
  });

  @override
  Widget build(BuildContext context) {
    List<String> cardNumberParts = Format.iban(cardNumber).split(" ");

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: defaultCardVerticalPadding,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: defaultCardHorizontalPadding,
                      ),
                      child: VisaSvgIcon(),
                    ),
                    if (isPrimary) const PrimaryDebitCardLabel(),
                    if (isViewable!) const EyeIcon(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  defaultCardHorizontalPadding,
                  15,
                  defaultCardHorizontalPadding,
                  25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...cardNumberParts.map((cardNumberPart) {
                      Text textContent = Text(
                        cardNumberPart,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          letterSpacing: 3,
                        ),
                      );
                      if (cardNumberPart == "****") {
                        return SizedBox(height: 20, child: textContent);
                      }

                      return textContent;
                    })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SpacedColumn(
                      space: 3,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "CARD HOLDER",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            height: 15 / 12,
                          ),
                        ),
                        Text(
                          cardHolder,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 20 / 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    SpacedColumn(
                      space: 3,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "EXPIRES",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            height: 15 / 12,
                          ),
                        ),
                        Text(
                          cardExpiry,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 20 / 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryDebitCardLabel extends StatelessWidget {
  const PrimaryDebitCardLabel({
    super.key,
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
          topLeft: Radius.circular(6),
          bottomLeft: Radius.circular(6),
        ),
      ),
      child: const Text(
        "Primary card",
        style: TextStyle(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w600,
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
      height: 40,
      width: 40,
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
    return const Icon(
      Icons.remove_red_eye_outlined,
      color: Colors.white,
      size: 25,
    );
  }
}
