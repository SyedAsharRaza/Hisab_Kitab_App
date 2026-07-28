import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/loaders/shimmer_loader.dart';
import '../../../../core/widgets/more/empty_state_widget.dart';
import '../../../../core/widgets/snackbars/custom_snackbars.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../ledger_entry/domain/entities/ledger_entry_entity.dart';
import '../../../ledger_entry/presentation/providers/ledger_provider.dart';
import '../../../ledger_entry/presentation/widgets/ledger_entry_tile.dart';
import '../../../ledger_entry/presentation/widgets/net_balance_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasStartedWatching = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onSettle(BuildContext context, LedgerEntryEntity entry) async {
    final ledgerProvider = context.read<LedgerProvider>();
    final success = await ledgerProvider.settleEntry(entry.id);
    if (!context.mounted) return;
    if (success) {
      CustomSnackbars.showSuccess(context, 'Settled up with ${entry.personName}');
    } else {
      CustomSnackbars.showError(
        context,
        ledgerProvider.errorMessage ?? 'Failed to settle. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final ledgerProvider = context.watch<LedgerProvider>();
    final userId = authProvider.currentUser?.uid;

    if (userId != null && !_hasStartedWatching) {
      _hasStartedWatching = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ledgerProvider.startWatching(userId);
      });
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            if (userId != null) ledgerProvider.startWatching(userId);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: context.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hisab Kitab',
                            style: AppTextStyle.h2.copyWith(fontSize: context.sp(20)),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authProvider.signOut();
                              if (context.mounted) context.go(RouteNames.login);
                            },
                            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(16)),
                      if (ledgerProvider.status == ViewStatus.loading)
                        ShimmerLoader(height: context.h(120), borderRadius: BorderRadius.circular(20))
                      else
                        NetBalanceCard(netBalance: ledgerProvider.netBalance),
                      SizedBox(height: context.h(20)),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: AppColors.textPrimary,
                          unselectedLabelColor: AppColors.textSecondary,
                          labelStyle: AppTextStyle.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: context.sp(13),
                          ),
                          dividerColor: Colors.transparent,
                          tabs: const [
                            Tab(text: 'Owed to Me'),
                            Tab(text: 'I Owe'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: true,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _EntryList(
                      entries: ledgerProvider.owedToMeEntries,
                      status: ledgerProvider.status,
                      emptyIcon: Icons.trending_up,
                      emptyTitle: 'No one owes you yet',
                      emptySubtitle: 'Entries where others owe you will show up here.',
                      onSettle: (entry) => _onSettle(context, entry),
                    ),
                    _EntryList(
                      entries: ledgerProvider.iOweEntries,
                      status: ledgerProvider.status,
                      emptyIcon: Icons.trending_down,
                      emptyTitle: "You don't owe anyone",
                      emptySubtitle: 'Debts you owe to others will show up here.',
                      onSettle: (entry) => _onSettle(context, entry),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => context.push(RouteNames.addEntry),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _EntryList extends StatelessWidget {
  final List<LedgerEntryEntity> entries;
  final ViewStatus status;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
  final void Function(LedgerEntryEntity) onSettle;

  const _EntryList({
    required this.entries,
    required this.status,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.onSettle,
  });

  @override
  Widget build(BuildContext context) {
    if (status == ViewStatus.loading) {
      return ListView.builder(
        padding: context.screenPadding,
        itemCount: 4,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: context.h(12)),
          child: ShimmerLoader(height: context.h(70)),
        ),
      );
    }
    if (entries.isEmpty) {
      return EmptyStateWidget(
        icon: emptyIcon,
        title: emptyTitle,
        subtitle: emptySubtitle,
      );
    }
    return ListView.builder(
      padding: context.screenPadding,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Padding(
          padding: EdgeInsets.only(bottom: context.h(12)),
          child: LedgerEntryTile(
            entry: entry,
            onSettleTap: () => onSettle(entry),
          ),
        );
      },
    );
  }
}