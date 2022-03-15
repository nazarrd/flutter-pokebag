import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Shimmers extends StatelessWidget {
  const Shimmers({Key? key, required this.isDark}) : super(key: key);
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    var shimmerColor = const Color(0xFFD1D1D1);
    var shimmerHighligtColor = Colors.grey[300];
    var shimmerColorDark = Colors.grey[600];
    var shimmerHighligtColorDark = Colors.grey;
    return Shimmer.fromColors(
      baseColor: isDark ? shimmerColorDark! : shimmerColor,
      highlightColor: isDark ? shimmerHighligtColorDark : shimmerHighligtColor!,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: shimmerColor,
        ),
      ),
    );
  }
}
