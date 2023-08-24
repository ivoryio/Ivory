import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/models/bank_card.dart';

import '../config.dart';
import '../utilities/format.dart';

class BankCardShowDetailsWidget extends StatelessWidget {
  final BankCardFetchedDetails cardDetails;
  final String? cardType;

  const BankCardShowDetailsWidget({
    super.key,
    required this.cardDetails,
    this.cardType,
  });

  void showAlertDialog(
      BuildContext context, String stringToCopy, String typeOfString) async {
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
              gradient: const LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0.0, 0.5629],
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
                            child: VisaSvgIcon(),
                          ),
                        ],
                      ),
                      if (cardType != null) CardTypeLabel(cardType: cardType!),
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
                            const Text(
                              "CARD NUMBER",
                              style: TextStyle(
                                fontSize: 12,
                                height: 16 / 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cardNumberParts.join(' '),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 24 / 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                                      showAlertDialog(context,
                                          cardNumberParts.join(' '), "Number");
                                      inspect(
                                        ClipboardData(
                                          text: cardNumberParts.join(' '),
                                        ),
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
                                const Text(
                                  "EXPIRY DATE",
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 16 / 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  cardDetails.cardExpiry,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 24 / 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 32),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "CVV",
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 16 / 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      cardDetails.cvv,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 24 / 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                                          showAlertDialog(
                                              context, cardDetails.cvv, "CVV");
                                          inspect(
                                            ClipboardData(
                                              text: cardDetails.cvv,
                                            ),
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
