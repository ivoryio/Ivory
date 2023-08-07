import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:solarisdemo/models/reward.dart';

class Rewards extends StatelessWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rewards = [
      Reward(
        provider: 'Porsche',
        providerIconUrl: '',
        description: '75% off Porsche driving experience',
        imageUrl:
            'https://hips.hearstapps.com/hmg-prod/images/2023-porsche-911-dakar-fd-152-1674829952.jpg?crop=0.640xw:0.541xh;0.202xw,0.290xh&resize=2048:*',
      ),
      Reward(
        provider: 'Porsche',
        providerIconUrl: '',
        description: '20% off at our Design Store',
        imageUrl:
            'https://www.jidp.or.jp/en/media/5620b8eb-f71b-4542-ac3d-08187beaa581?w=640&h=360&m=1',
      ),
      Reward(
        provider: 'Porsche',
        providerIconUrl: '',
        description: '25% off for luxury accommodations',
        imageUrl:
            'https://media.cntraveler.com/photos/5f89a04c832eef138f7b94e9/master/w_1600%2Cc_limit/Dorado%2520Beach%2C%2520a%2520Ritz-Carlton%2520Reserve.jpg',
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
            Image.network(
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
                      child: Image.asset('assets/icons/porsche/small_logo.png',
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
