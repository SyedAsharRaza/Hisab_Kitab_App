import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

// simple sa shimmer - koi package use nahi kara.
class ShimmerLoader extends StatefulWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;
  const ShimmerLoader({
    super.key,
    this.height = 60,
    this.width = double.infinity,
    this.borderRadius,
  });
  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}


// yahan animations use karunga - DONE
class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment(-1 + _controller.value * 2, 0),
              end: Alignment(1 + _controller.value * 2, 0),
              colors: const [
                AppColors.shimmerBase,
                AppColors.shimmerHighlight,
                AppColors.shimmerBase,
              ],
              stops: const [0.3, 0.5, 0.7],
            ),
          ),
        );
      },
    );
  }
}