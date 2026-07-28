import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loaders/custom_loader.dart';

// initial location is par set hay
// ye thore time ke lie show hoga jab tak onboarding status and current User ko check nhi kar leta
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: CustomLoader(color: Colors.white),
      ),
    );
  }
}