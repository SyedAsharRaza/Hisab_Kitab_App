import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/injection_container.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/local_storage/local_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/animated/primary_button.dart';
import '../models/onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      title: 'Track Every Cash Loan',
      description:
      'Log money you lend or borrow from friends and family in seconds — no more mental math or forgotten IOUs.',
      icon: Icons.receipt_long_outlined,
      accentColor: AppColors.primary,
    ),
    OnboardingSlide(
      title: 'See Your Net Balance',
      description:
      'One glance tells you exactly where you stand — who owes you, who you owe, and your overall position.',
      icon: Icons.account_balance_wallet_outlined,
      accentColor: AppColors.receivable,
    ),
    OnboardingSlide(
      title: 'Settle Up, Hassle-Free',
      description:
      'One tap clears a debt and updates your balance instantly. Keep accounts clean and friendships clutter-free.',
      icon: Icons.handshake_outlined,
      accentColor: AppColors.payable,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final localStorage = sl<LocalStorageService>();
    await localStorage.setBool(AppConstants.keyHasSeenOnboarding, true);
    if (mounted) context.go(RouteNames.login);
  }

  void _onNext() {
    if (_currentPage == _slides.length - 1) {
      _finishOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(20), vertical: context.h(12)),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: Text(
                    'Skip',
                    style: AppTextStyle.bodyMedium.copyWith(
                      fontSize: context.sp(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder( // best for onboarding screens
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _SlideContent(slide: _slides[index]),
              ),
            ),
            _DotsIndicator(count: _slides.length, currentIndex: _currentPage),
            Padding(
              padding: context.screenPadding,
              child: PrimaryButton(
                label: isLastPage ? 'Get Started' : 'Next',
                onPressed: _onNext,
              ),
            ),
            SizedBox(height: context.h(16)),
          ],
        ),
      ),
    );
  }
}

class _SlideContent extends StatelessWidget {
  final OnboardingSlide slide;
  const _SlideContent({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(32)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: context.w(140),
            height: context.w(140),
            decoration: BoxDecoration(
              color: slide.accentColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: context.w(60), color: slide.accentColor),
          ),
          SizedBox(height: context.h(40)),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: AppTextStyle.h1.copyWith(fontSize: context.sp(24)),
          ),
          SizedBox(height: context.h(14)),
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: AppTextStyle.bodyLarge.copyWith(
              fontSize: context.sp(15),
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  const _DotsIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: context.w(4)),
          width: isActive ? context.w(22) : context.w(8),
          height: context.h(8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.divider,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}