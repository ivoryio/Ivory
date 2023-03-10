import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solaris_structure_1/cubits/person_cubit/person_cubit.dart';
import 'package:solaris_structure_1/services/person_service.dart';

import '../cubits/auth_cubit/auth_cubit.dart';
import '../models/oauth_model.dart';

class PersonHomeHeader extends StatelessWidget {
  const PersonHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    OauthModel oAuth = context.read<AuthCubit>().state.oauthModel!;
    return BlocProvider(
      create: (context) => PersonCubit(
        personService: PersonService(oauth: oAuth),
      )..getPerson(),
      child: BlocBuilder<PersonCubit, PersonCubitState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case PersonCubitInitial:
              return const Placeholder();
            case PersonCubitLoading:
              return const CircularProgressIndicator();
            case PersonCubitError:
              return const Text("Person could not be loaded");
            case PersonCubitLoaded:
              var person = state.person;
              return Column(
                children: [
                  Text(person!.firstName!),
                  Text(person.lastName!),
                ],
              );
            default:
              return const Text("Person could not be loaded");
          }
        },
      ),
    );
  }
}
