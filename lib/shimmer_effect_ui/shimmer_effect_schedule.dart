import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffectSchedule extends StatelessWidget {
  final double height;
  final double width;

  const ShimmerEffectSchedule({
    super.key,
    this.height = 120.0, // Adjusted height to match schedule card
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(milliseconds: 1000),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}