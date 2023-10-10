import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/themes/default_theme.dart';

import '../utilities/format.dart';

const double defaultCardHorizontalPadding = 20;
const double defaultCardVerticalPadding = 15;
const double defaultHeigth = 202;
const double defaultWidth = 343;

class BankCardWidget extends StatelessWidget {
  final bool showCardDetails;
  final String? cardHolder;
  final String? cardNumber;
  final String? cardExpiry;
  final BankCardType? cardType;
  final double? customHeight;
  final double? customWidth;
  final double? imageScaledownFactor;
  final bool isFrozen;

  const BankCardWidget({
    super.key,
    this.showCardDetails = true,
    this.customHeight,
    this.customWidth,
    this.cardExpiry,
    this.cardHolder,
    this.cardNumber,
    this.cardType,
    this.imageScaledownFactor = 1,
    this.isFrozen = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: customWidth ?? defaultWidth,
      height: customHeight ?? defaultHeigth,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: _buildGradient(),
          ),
          child: Stack(
            children: _buildBackgroundLayers()..add(_buildCardContent()),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    List<String> cardNumberParts = Format.iban(cardNumber ?? '').split(" ");

    return Padding(
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
                child: CardTypeIcon(),
              ),
              if (showCardDetails && cardType != null) CardTypeLabel(cardType: cardType!),
            ],
          ),
          const Spacer(),
          if (showCardDetails == true) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...cardNumberParts.map((cardNumberPart) {
                    Text textContent = Text(
                      cardNumberPart,
                      style: ClientConfig.getTextStyleScheme().heading2.copyWith(color: Colors.white),
                    );
                    if (cardNumberPart == "****") {
                      return SizedBox(height: 29, child: textContent);
                    }
                    return textContent;
                  })
                ],
              ),
            ),
            const Spacer(),
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
                      if (cardHolder != null && cardHolder!.isNotEmpty)
                        Text(
                          "CARD HOLDER",
                          style: ClientConfig.getTextStyleScheme().labelCaps.copyWith(color: Colors.white),
                        ),
                      if (cardHolder != null) const SizedBox(height: 3),
                      Text(
                        cardHolder ?? '',
                        style: ClientConfig.getTextStyleScheme().labelMedium.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (cardExpiry != null && cardExpiry!.isNotEmpty)
                        Text(
                          "EXPIRY DATE",
                          style: ClientConfig.getTextStyleScheme().labelCaps.copyWith(color: Colors.white),
                        ),
                      if (cardExpiry != null) const SizedBox(height: 3),
                      Text(
                        cardExpiry ?? '',
                        style: ClientConfig.getTextStyleScheme().labelMedium.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }

  LinearGradient _buildGradient() {
    if (isFrozen) {
      return const LinearGradient(
        begin: Alignment(-1.0, -1.0),
        end: Alignment(1.0, 1.0),
        colors: [
          Color(0xFFCFD4D9),
          Color(0xFF56555E),
        ],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          ClientConfig.getColorScheme().surfaceVariant,
          ClientConfig.getColorScheme().outline,
        ],
      );
    }
  }

  List<Widget> _buildBackgroundLayers() {
    if (isFrozen == true) {
      return [
        Positioned.fill(
          child: Image.asset(
            ClientConfig.getAssetImagePath('frozen_card_logo.png'),
            fit: BoxFit.scaleDown,
            scale: imageScaledownFactor,
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              'assets/images/frozen_card.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.20),
                  Colors.white.withOpacity(0.20),
                ],
              ),
            ),
          ),
        )
      ];
    }

    return [
      Positioned.fill(
        child: Image.asset(
          ClientConfig.getAssetImagePath('card_logo.png'),
          fit: BoxFit.scaleDown,
          scale: imageScaledownFactor,
        ),
      )
    ];
  }
}

class CardTypeLabel extends StatelessWidget {
  final BankCardType cardType;

  const CardTypeLabel({
    super.key,
    required this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(1000),
          bottomLeft: Radius.circular(1000),
        ),
      ),
      child: Text(
        cardType.toString().toLowerCase().contains('virtual') ? 'Virtual card' : 'Physical card',
        style: ClientConfig.getTextStyleScheme().labelXSmall.copyWith(color: Colors.black, height: 1.2),
      ),
    );
  }
}

class CardTypeIcon extends StatelessWidget {
  const CardTypeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ClientConfig.getClientConfig().uiSettings.cardType == CardType.visa
        ? SvgPicture.asset(
            "assets/icons/visa_pay_logo.svg",
            height: 40,
            width: 40,
            placeholderBuilder: (context) => const Text("VISA"),
          )
        : SvgPicture.asset(
            "assets/icons/mastercard_logo.svg",
            height: 16,
            width: 26,
            placeholderBuilder: (context) => const Text("Mastercard"),
          );
  }
}
