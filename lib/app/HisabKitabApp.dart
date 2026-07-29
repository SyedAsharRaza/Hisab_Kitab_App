import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/ledger_entry/presentation/providers/ledger_provider.dart';
import 'injection_container.dart';

class HisabKitabApp extends StatefulWidget {
  const HisabKitabApp({super.key});

  @override
  State<HisabKitabApp> createState() => _HisabKitabAppState();
}

class _HisabKitabAppState extends State<HisabKitabApp> {
  late final AuthProvider _authProvider;
  late final LedgerProvider _ledgerProvider;
  late final GoRouter _router;

  @override
  void initState() {
    _authProvider = sl<AuthProvider>();
    _ledgerProvider = sl<LedgerProvider>();
    _router = AppRouter.build(authProvider: _authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: _authProvider),
        ChangeNotifierProvider<LedgerProvider>.value(value: _ledgerProvider),
      ],
      child: MaterialApp.router(
        title: 'Hisab Kitab',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            background: AppColors.background,
          ),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}