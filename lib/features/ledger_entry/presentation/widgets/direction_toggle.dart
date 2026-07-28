import 'package:flutter/material.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

// toggle widget : i owe them / they owe me
class DirectionToggle extends StatelessWidget {
  final LedgerDirection selected;
  final ValueChanged<LedgerDirection> onChanged;
  const DirectionToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(4)),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _OptionTile(
              label: 'They owe me',
              isSelected: selected == LedgerDirection.theyOweMe,
              activeColor: AppColors.receivable,
              onTap: () => onChanged(LedgerDirection.theyOweMe),
            ),
          ),
          SizedBox(width: context.w(4)),
          Expanded(
            child: _OptionTile(
              label: 'I owe them',
              isSelected: selected == LedgerDirection.iOweThem,
              activeColor: AppColors.payable,
              onTap: () => onChanged(LedgerDirection.iOweThem),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: context.h(12)),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyMedium.copyWith(
            fontSize: context.sp(13),
            fontWeight: FontWeight.w600,
            color: isSelected ? activeColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}