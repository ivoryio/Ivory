import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/widgets/button.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../models/user.dart';
import '../../services/device_service.dart';
import '../../widgets/screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User user = context.read<AuthCubit>().state.user!.cognito;
    return Screen(
      title: "Profile",
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 200,
              height: 50,
              child: PrimaryButton(
                  text: 'Create device binding',
                  onPressed: () async {
                    //create device binding
                    DeviceService deviceService = DeviceService(user: user);
                    await deviceService.createDeviceBinding(user.personId!);
                  }),
            ),
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: PrimaryButton(
                  text: 'Verify device binding',
                  onPressed: () async {
                    // verify device binding signature
                    DeviceService deviceService = DeviceService(user: user);
                    await deviceService.verifyDeviceBindingSignature(
                        '212212'); // verify device with static TAN - To be refactored
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
