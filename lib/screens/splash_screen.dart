import 'package:fladder/models/account_model.dart';
import 'package:fladder/providers/shared_provider.dart';
import 'package:fladder/providers/user_provider.dart';
import 'package:fladder/routes/build_routes/home_routes.dart';
import 'package:fladder/routes/build_routes/route_builder.dart';
import 'package:fladder/screens/shared/fladder_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      final AccountModel? lastUsedAccount = ref.read(sharedUtilityProvider).getActiveAccount();
      ref.read(userProvider.notifier).updateUser(lastUsedAccount);

      if (context.mounted) {
        if (lastUsedAccount == null) {
          context.routeGo(LoginRoute());
        } else {
          switch (lastUsedAccount.authMethod) {
            case Authentication.autoLogin:
              context.routeGo(DashboardRoute());
              break;
            case Authentication.biometrics:
            case Authentication.none:
            case Authentication.passcode:
              context.routeReplace(LoginRoute());
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
