import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/models/account_model.dart';
import 'package:fladder/providers/shared_provider.dart';
import 'package:fladder/providers/user_provider.dart';
import 'package:fladder/screens/shared/fladder_logo.dart';

@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  final Function(bool loggedIn)? loggedIn;
  const SplashScreen({this.loggedIn, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) async {
      await Future.delayed(const Duration(milliseconds: 500));
      final AccountModel? lastUsedAccount = ref.read(sharedUtilityProvider).getActiveAccount();
      ref.read(userProvider.notifier).updateUser(lastUsedAccount);

      if (context.mounted) {
        if (lastUsedAccount == null) {
          widget.loggedIn?.call(false);
          context.router.maybePop(false);
        } else {
          switch (lastUsedAccount.authMethod) {
            case Authentication.autoLogin:
              widget.loggedIn?.call(true);
              context.router.maybePop(true);
              break;
            case Authentication.biometrics:
            case Authentication.none:
            case Authentication.passcode:
              widget.loggedIn?.call(false);
              context.router.maybePop(false);
              break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FractionallySizedBox(
          heightFactor: 0.4,
          child: FladderLogo(),
        ),
      ),
    );
  }
}
