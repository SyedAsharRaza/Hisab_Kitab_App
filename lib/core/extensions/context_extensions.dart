import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

// important extensions (took help from Sir Moeen's Repo)

import 'package:flutter/material.dart';
import '../config/responsive_config.dart';

extension ContextExtensions on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;


  // ab ye responsive config ko use karega
  double w(double value) => ResponsiveConfig.width(value);
  double h(double value) => ResponsiveConfig.height(value);
  double sp(double value) => ResponsiveConfig.scale(value);

  bool get isSmallScreen => screenWidth < 360;
  bool get isTablet => ResponsiveConfig.isTablet;

  EdgeInsets get screenPadding => EdgeInsets.symmetric(
    horizontal: w(20),
    vertical: h(16),
  );

  double get bottomSafeArea => MediaQuery.of(this).padding.bottom;
  double get topSafeArea => MediaQuery.of(this).padding.top;
}