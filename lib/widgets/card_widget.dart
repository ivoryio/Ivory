import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';

import '../utilities/format.dart';

const double defaultCardHorizontalPadding = 20;
const double defaultCardVerticalPadding = 15;
const double defaultHeigth = 202;
const double defaultWidth = 343;

class BankCardWidget extends StatelessWidget {
  final bool? isCardEmpty;
  final String? cardHolder;
  final String? cardNumber;
  final String? cardExpiry;
  final bool? isViewable;
  final String? cardType;
  final double? customHeight;
  final double? customWidth;
  final double? imageScaledownFactor;

  const BankCardWidget({
    super.key,
    this.isCardEmpty = false,
    this.customHeight,
    this.customWidth,
    this.cardExpiry,
    this.cardHolder,
    this.cardNumber,
    this.isViewable = true,
    this.cardType,
    this.imageScaledownFactor,
  });

  @override
  Widget build(BuildContext context) {
    List<String> cardNumberParts = Format.iban(cardNumber ?? '').split(" ");

    return SizedBox(
      width: customWidth ?? defaultWidth,
      height: customHeight ?? defaultHeigth,
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
              stops: [0.0, 1.0],
              colors: [
                Color(0xFF1D26A7),
                Color(0xFF6300BB),
              ],
              transform: GradientRotation(135 * (3.1415926 / 180.0)),
            ),
            image: DecorationImage(
              image:
                  AssetImage(ClientConfig.getAssetImagePath('card_logo.png')),
              fit: BoxFit.scaleDown,
              scale: imageScaledownFactor ?? 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                      ),
                      child: VisaSvgIcon(),
                    ),
                    if (isViewable!) const EyeIcon(),
                    if (cardType != null) CardTypeLabel(cardType: cardType!),
                  ],
                ),
                const Spacer(),
                if (isCardEmpty != true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            return SizedBox(height: 29, child: textContent);
                          }

                          return textContent;
                        })
                      ],
                    ),
                  ),
                if (isCardEmpty != true) const Spacer(),
                if (isCardEmpty != true)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (cardHolder != null)
                              const Text(
                                "CARD HOLDER",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  height: 15 / 12,
                                ),
                              ),
                            if (cardHolder != null) const SizedBox(height: 3),
                            Text(
                              cardHolder ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 20 / 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (cardExpiry != null)
                              const Text(
                                "EXPIRES",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  height: 15 / 12,
                                ),
                              ),
                            if (cardExpiry != null) const SizedBox(height: 3),
                            Text(
                              cardExpiry ?? '',
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
        horizontal: 16,
        vertical: 4,
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
