import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:solarisdemo/models/reward.dart';

class Rewards extends StatelessWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rewards = [
      Reward(
        provider: 'Louis Vuitton',
        providerIconUrl: 'assets/images/logo_reward_1.png',
        description: '20% off at Louis Vuitton',
        imageUrl: 'assets/images/Reward card_1.jpg',
      ),
      Reward(
        provider: 'Four Seasons',
        providerIconUrl: 'assets/images/logo_reward_2.png',
        description: '25% off for luxury accommodations',
        imageUrl: 'assets/images/Reward card_2.jpg',
      ),
      Reward(
        provider: 'Facil',
        providerIconUrl: 'assets/images/logo_reward_3.png',
        description: '10% off for fine dining experience',
        imageUrl: 'assets/images/Reward card_3.jpg',
      ),
      Reward(
        provider: 'Ferrari',
        providerIconUrl: 'assets/images/logo_reward_4.png',
        description: '75% off driving experience',
        imageUrl: 'assets/images/Reward card_4.jpg',
      ),
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Rewards",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            PlatformTextButton(
              padding: EdgeInsets.zero,
              child: const Text(
                "See all",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFCC0000),
                ),
              ),
              onPressed: () {},
            )
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return RewardCard(
                reward: rewards[index],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemCount: rewards.length,
          ),
        ),
      ],
    );
  }
}

class RewardCard extends StatelessWidget {
  const RewardCard({Key? key, required this.reward}) : super(key: key);
  final Reward reward;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: 260,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              reward.imageUrl,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(reward.providerIconUrl,
                          width: 24, height: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    reward.provider,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    reward.description,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
