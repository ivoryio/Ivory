import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/widgets/card_widget.dart';
import 'package:solarisdemo/widgets/snackbar.dart';

import '../config.dart';
import '../utilities/format.dart';

class BankCardShowDetailsWidget extends StatelessWidget {
  final BankCardFetchedDetails cardDetails;
  final BankCardType? cardType;
  final String? cardTypeLabel;

  const BankCardShowDetailsWidget({
    super.key,
    required this.cardDetails,
    this.cardTypeLabel,
    this.cardType,
  });

  void showAlertDialog(BuildContext context, String stringToCopy, String typeOfString) async {
    copyToClipboard(stringToCopy);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Card $typeOfString successfully copied: $stringToCopy",
          style: const TextStyle(color: Colors.black),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  void copyToClipboard(String stringToCopy) {
    Clipboard.setData(ClipboardData(text: stringToCopy));
  }

  @override
  Widget build(BuildContext context) {
    List<String> cardNumberParts = Format.iban(cardDetails.cardNumber).split(" ");

    return SizedBox(
      width: 310,
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
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ClientConfig.getColorScheme().surfaceVariant,
                  ClientConfig.getColorScheme().outline,
                ],
              ),
              image: DecorationImage(
                image: AssetImage(ClientConfig.getAssetImagePath('card_logo.png')),
                fit: BoxFit.scaleDown,
              ),
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
                            child: CardTypeIcon(),
                          ),
                        ],
                      ),
                      if (cardTypeLabel != null) CardTypeLabel(cardType: cardTypeLabel!),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CARD NUMBER",
                              style: ClientConfig.getTextStyleScheme().labelCaps.copyWith(color: Colors.white),
                            ),
                            Row(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cardNumberParts.join(' '),
                                      style:
                                          ClientConfig.getTextStyleScheme().labelMedium.copyWith(color: Colors.white),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0.0),
                                    iconSize: 24,
                                    icon: const Icon(
                                      Icons.content_copy,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      showSnackbar(
                                        context,
                                        text: "Copied to clipboard",
                                        icon: const Icon(Icons.copy, color: Colors.white),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "EXPIRY DATE",
                                  style: ClientConfig.getTextStyleScheme().labelCaps.copyWith(color: Colors.white),
                                ),
                                Text(
                                  cardDetails.cardExpiry,
                                  style: ClientConfig.getTextStyleScheme().labelMedium.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(width: 32),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CVV",
                                  style: ClientConfig.getTextStyleScheme().labelCaps.copyWith(color: Colors.white),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      cardDetails.cvv,
                                      style:
                                          ClientConfig.getTextStyleScheme().labelMedium.copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0.0),
                                        iconSize: 24,
                                        icon: const Icon(
                                          Icons.content_copy,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          showSnackbar(
                                            context,
                                            text: "Copied to clipboard",
                                            icon: const Icon(Icons.copy, color: Colors.white),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
        cardType,
        style: ClientConfig.getTextStyleScheme().labelXSmall.copyWith(color: Colors.black, height: 1.2),
      ),
    );
  }
}
