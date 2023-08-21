import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class ChangePinScreen extends StatelessWidget {
  static const routeName = "/changePinScreen";

  const ChangePinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: AppToolbar(
              richTextTitle: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Step 1',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF15141E),
                      ),
                    ),
                    TextSpan(
                      text: " out of 2",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF56555E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const PreferredSize(
            preferredSize: Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: 0.05,
              color: Color(0xFF2575FC),
              backgroundColor: Color(0xFFADADB4),
            ),
          ),
          ChangePinBody(),
          const Spacer(),
          const ChangePinChecks(),
        ],
      ),
    );
  }
}

class ChangePinBody extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  ChangePinBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose PIN",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Remember your PIN as you will use it for all future card purchases.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xffadadb4),
                ),
              );
            }),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            child: TextField(
              autofocus: true,
              controller: _controller,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration.collapsed(
                hintText: 'PIN',
              ),
              style: TextStyle(
                color: Colors.grey.withOpacity(0),
              ),
              cursorColor: Colors.transparent,
              cursorRadius: const Radius.circular(0),
              cursorWidth: 0,
              onChanged: (text) {
                print("Typed text: $text");
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePinChecks extends StatelessWidget {
  const ChangePinChecks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your PIN should not contain:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Icon(
                Icons.close,
                size: 24,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "Your date of birth",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.close,
                size: 24,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "Your postal code",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.close,
                size: 24,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "Number sequences, e.g. 1234",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.close,
                size: 24,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "More than two digits repeating",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
