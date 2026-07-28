import 'package:flutter/material.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/cards/custom_card.dart';
import '../../domain/entities/ledger_entry_entity.dart';

class LedgerEntryTile extends StatelessWidget {
  final LedgerEntryEntity entry;
  final VoidCallback onSettleTap;
  const LedgerEntryTile({
    super.key,
    required this.entry,
    required this.onSettleTap,
  });

  @override
  Widget build(BuildContext context) {
    final isReceivable = entry.direction == LedgerDirection.theyOweMe;
    final accentColor = isReceivable ? AppColors.receivable : AppColors.payable;
    final bgColor = isReceivable ? AppColors.receivableBg : AppColors.payableBg;
    return CustomCard(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
      child: Row(
        children: [
          CircleAvatar(
            radius: context.w(22),
            backgroundColor: bgColor,
            child: Text(
              entry.personName.isNotEmpty ? entry.personName[0].toUpperCase() : '?',
              style: AppTextStyle.h3.copyWith(color: accentColor, fontSize: context.sp(16)),
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.personName,
                  style: AppTextStyle.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(15),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (entry.note.isNotEmpty) ...[
                  SizedBox(height: context.h(2)),
                  Text(
                    entry.note,
                    style: AppTextStyle.bodySmall.copyWith(fontSize: context.sp(12)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: context.w(8)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${entry.amount.toStringAsFixed(2)}',
                style: AppTextStyle.bodyLarge.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                  fontSize: context.sp(15),
                ),
              ),
              SizedBox(height: context.h(6)),
              GestureDetector(
                onTap: onSettleTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(4)),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Settle Up',
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: context.sp(11),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}