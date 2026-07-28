import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_style.dart';

//consistent hay

class CustomSnackbars {
  CustomSnackbars._();
  static void showError(BuildContext context, String message) {
    _show(context, message: message, background: AppColors.error, icon: Icons.error_outline);
  }
  static void showSuccess(BuildContext context, String message) {
    _show(context, message: message, background: AppColors.success, icon: Icons.check_circle_outline);
  }
  static void _show(
      BuildContext context, {
        required String message,
        required Color background,
        required IconData icon,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyle.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }
}