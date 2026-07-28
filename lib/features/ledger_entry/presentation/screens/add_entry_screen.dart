import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/animated/primary_button.dart';
import '../../../../core/widgets/input/custom_text_field.dart';
import '../../../../core/widgets/snackbars/custom_snackbars.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/ledger_entry_entity.dart';
import '../providers/ledger_provider.dart';
import '../widgets/direction_toggle.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  LedgerDirection _direction = LedgerDirection.theyOweMe;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    final ledgerProvider = context.read<LedgerProvider>();
    final userId = authProvider.currentUser?.uid;
    if (userId == null) {
      CustomSnackbars.showError(context, 'Something went wrong. Please log in again.');
      return;
    }
    final entry = LedgerEntryEntity(
      id: '', // add karne par firestore id assign kar deta hay
      userId: userId,
      personName: _nameController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      note: _noteController.text.trim(),
      direction: _direction,
      status: LedgerStatus.pending,
      createdAt: DateTime.now(),
    );
    final success = await ledgerProvider.addEntry(entry);
    if (!mounted) return;
    if (success) {
      CustomSnackbars.showSuccess(context, 'Entry added successfully');
      context.pop();
    } else {
      CustomSnackbars.showError(
        context,
        ledgerProvider.errorMessage ?? 'Failed to save entry. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ledgerProvider = context.watch<LedgerProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close, color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox(width: context.w(4)),
                    Text('New Entry', style: AppTextStyle.h2.copyWith(fontSize: context.sp(20))),
                  ],
                ),
                SizedBox(height: context.h(20)),
                Text(
                  'Who is this with?',
                  style: AppTextStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(13),
                  ),
                ),
                SizedBox(height: context.h(10)),
                DirectionToggle(
                  selected: _direction,
                  onChanged: (value) => setState(() => _direction = value),
                ),
                SizedBox(height: context.h(22)),
                CustomTextField(
                  label: "Person's Name",
                  controller: _nameController,
                  validator: Validators.name,
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.textHint),
                ),
                SizedBox(height: context.h(18)),
                CustomTextField(
                  label: 'Amount',
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: Validators.amount,
                  prefixIcon: const Icon(Icons.attach_money, color: AppColors.textHint),
                ),
                SizedBox(height: context.h(18)),
                CustomTextField(
                  label: 'Note / Reason',
                  controller: _noteController,
                  hint: 'e.g. Lunch money, Fuel split',
                  maxLines: 2,
                  prefixIcon: const Icon(Icons.notes_outlined, color: AppColors.textHint),
                ),
                SizedBox(height: context.h(32)),
                PrimaryButton(
                  label: 'Save Entry',
                  isLoading: ledgerProvider.isSubmitting,
                  onPressed: _onSave,
                  color: _direction == LedgerDirection.theyOweMe
                      ? AppColors.receivable
                      : AppColors.payable,
                ),
                SizedBox(height: context.h(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}