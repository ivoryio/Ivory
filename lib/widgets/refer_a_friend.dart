import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ReferAFriend extends StatelessWidget {
  const ReferAFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Refer a friend",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 48,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.black,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Flexible(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Invite a friend and get \$15",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Flexible(
                      child: Text(
                        softWrap: true,
                        textAlign: TextAlign.center,
                        "Give a friend promo code on \$15 and you'll get \$15.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                color: Colors.white,
                strokeWidth: 1.5,
                strokeCap: StrokeCap.round,
                dashPattern: const [5, 5],
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PlatformIconButton(
                            onPressed: () {
                              log("copy refer a friend code");
                            },
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.copy_all,
                              color: Colors.white,
                            )),
                        const Text(
                          "SLRS3124",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: PlatformElevatedButton(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    onPressed: () {},
                    child: const Text(
                      'Invite friends',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
