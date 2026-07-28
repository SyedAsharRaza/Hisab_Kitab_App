import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// full screen loading and inline loading ke lie.
class CustomLoader extends StatelessWidget {
  final double size;
  final Color? color;
  const CustomLoader({super.key, this.size = 28, this.color});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.6,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
        ),
      ),
    );
  }
}