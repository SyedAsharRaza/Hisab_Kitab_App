import 'package:flutter/material.dart';
import '../services/logger/logger_service.dart';


class ResponsiveConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late Orientation orientation;
  static late bool isTablet;

  static late double mobileReferenceHeight;
  static late double mobileReferenceWidth;
  static late double tabletReferenceHeight;
  static late double tabletReferenceWidth;

  static bool _initialized = false;

  static void init(
      BuildContext context, {
        Size mobileSize = const Size(375, 812),
        Size tabletSize = const Size(834, 1194),
        bool isDebugPrint = false,
        bool Function(Size size)? customTabletCheck,
      }) {
    final size = MediaQuery.of(context).size;

    screenWidth = size.width;
    screenHeight = size.height;
    orientation = MediaQuery.of(context).orientation;

    mobileReferenceHeight = mobileSize.height;
    mobileReferenceWidth = mobileSize.width;
    tabletReferenceHeight = tabletSize.height;
    tabletReferenceWidth = tabletSize.width;

    isTablet = customTabletCheck != null
        ? customTabletCheck(size)
        : _defaultTabletCheck(size);

    _initialized = true;

    if (isDebugPrint) {
      AppLogger.debug(
        'Screen: ${screenWidth.toStringAsFixed(1)}x${screenHeight.toStringAsFixed(1)}, isTablet: $isTablet',
        'ResponsiveConfig',
      );
    }
  }

  static bool _defaultTabletCheck(Size size) {
    final shortestSide = size.shortestSide;
    return shortestSide >= 600 && (size.height / size.width) < 1.6;
  }

  static double height(double inputHeight) {
    _assertInitialized();
    final refHeight = isTablet ? tabletReferenceHeight : mobileReferenceHeight;
    return (inputHeight / refHeight) * screenHeight;
  }

  static double width(double inputWidth) {
    _assertInitialized();
    final refWidth = isTablet ? tabletReferenceWidth : mobileReferenceWidth;
    return (inputWidth / refWidth) * screenWidth;
  }

  static double scale(double fontSize) {
    _assertInitialized();
    final refWidth = isTablet ? tabletReferenceWidth : mobileReferenceWidth;
    return (fontSize / refWidth) * screenWidth;
  }

  static double radius(double radius) {
    _assertInitialized();
    final refWidth = isTablet ? tabletReferenceWidth : mobileReferenceWidth;
    return (radius / refWidth) * screenWidth;
  }

  static void _assertInitialized() {
    if (!_initialized) {
      throw FlutterError(
        'ResponsiveConfig not initialized. Wrap your app with ResponsiveProvider.',
      );
    }
  }
}

/// Wraps the app and initializes ResponsiveConfig on every build,
/// so orientation changes are picked up automatically.
class ResponsiveProvider extends StatelessWidget {
  final Widget child;
  final Size mobileSize;
  final Size tabletSize;
  final bool isDebugPrint;
  final bool Function(Size size)? customTabletCheck;

  const ResponsiveProvider({
    super.key,
    required this.child,
    this.mobileSize = const Size(375, 812),
    this.tabletSize = const Size(834, 1194),
    this.isDebugPrint = false,
    this.customTabletCheck,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ResponsiveConfig.init(
          context,
          mobileSize: mobileSize,
          tabletSize: tabletSize,
          isDebugPrint: isDebugPrint,
          customTabletCheck: customTabletCheck,
        );
        return child;
      },
    );
  }
}