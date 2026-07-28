import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

// important extensions (took help from Sir Moeen's Repo)

extension ContextExtensions on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  double get _widthScale => screenWidth / AppConstants.designWidth;
  double get _heightScale => screenHeight / AppConstants.designHeight;

  double w(double value) => value * _widthScale;

  double h(double value) => value * _heightScale;

  double sp(double value) {
    final scale = _widthScale < _heightScale ? _widthScale : _heightScale;
    final clamped = scale.clamp(0.8, 1.3);
    return value * clamped;
  }

  bool get isSmallScreen => screenWidth < 360;
  bool get isTablet => screenWidth >= 600;

  EdgeInsets get screenPadding => EdgeInsets.symmetric(
    horizontal: w(20),
    vertical: h(16),
  );

  double get bottomSafeArea => MediaQuery.of(this).padding.bottom;
  double get topSafeArea => MediaQuery.of(this).padding.top;
}