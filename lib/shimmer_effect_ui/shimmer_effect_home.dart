import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffectHome extends StatelessWidget {
  final double height;
  final double width;

  const ShimmerEffectHome({
    super.key,
    this.height = 140.0, // Default height for subject cards
    this.width = 100.0,  // Default width for subject cards
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