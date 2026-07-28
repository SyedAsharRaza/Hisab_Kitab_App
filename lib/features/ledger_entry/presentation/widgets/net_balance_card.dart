import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

// main card jo k dashboard screen par hoga
// ya to net receivable hoga ya net payable hoga
class NetBalanceCard extends StatelessWidget {
  final double netBalance;
  const NetBalanceCard({super.key, required this.netBalance});
  @override
  Widget build(BuildContext context) {
    final isPositive = netBalance >= 0;
    final color = isPositive ? AppColors.receivable : AppColors.payable;
    final label = isPositive ? 'Net Receivable' : 'Net Payable';
    final amountText = '\$${netBalance.abs().toStringAsFixed(2)}';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: context.h(24), horizontal: context.w(20)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Net Balance',
            style: AppTextStyle.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.75),
              fontSize: context.sp(13),
            ),
          ),
          SizedBox(height: context.h(10)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : '-'}$amountText',
                style: AppTextStyle.amountLarge.copyWith(
                  color: Colors.white,
                  fontSize: context.sp(30),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(8)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(4)),
            decoration: BoxDecoration(
              color: color.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: AppTextStyle.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: context.sp(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}