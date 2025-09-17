import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../constant/app_images/app_images.dart';

class LoadingWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final Color baseColor;
  final Color highlightColor;
  const LoadingWidget({
    super.key,
    this.width,
    this.height,
    this.child,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 200.w,
      height: height ?? 100.h,
      child: child ??
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Image.asset(logoPngImage),
          ),
    );
  }
}
