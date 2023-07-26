import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config.dart';
import '../utilities/format.dart';

class BankCardShowDetailsWidget extends StatelessWidget {
  final String cardNumber;
  final String cardExpiry;
  final String cardCvv;
  final String? cardType;

  const BankCardShowDetailsWidget({
    super.key,
    required this.cardNumber,
    required this.cardExpiry,
    required this.cardCvv,
    this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    List<String> cardNumberParts = Format.iban(cardNumber).split(" ");

    return SizedBox(
      // width: double.infinity,
      width: 295,
      height: 192,
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
                              "CARD HOLDER",
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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    alignment: Alignment.centerLeft,
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {},
                                  child: const Icon(
                                    Icons.content_copy,
                                    color: Colors.white,
                                    size: 24,
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
                                  "EXPIRAY DATE",
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 16 / 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  cardCvv,
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
                                  children: [
                                    Text(
                                      cardCvv,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 24 / 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        alignment: Alignment.centerLeft,
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () {},
                                      child: const Icon(
                                        Icons.content_copy,
                                        color: Colors.white,
                                        size: 24,
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
                    // const SizedBox(height: 16),
                    // const Row(),
                    //   ],
                    // ),
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
