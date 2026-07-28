import 'package:flutter/material.dart';
import '../../extensions/context_extensions.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_style.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(40)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: context.w(56), color: AppColors.textHint),
            SizedBox(height: context.h(16)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.h3.copyWith(fontSize: context.sp(16)),
            ),
            SizedBox(height: context.h(6)),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium.copyWith(fontSize: context.sp(13)),
            ),
          ],
        ),
      ),
    );
  }
}