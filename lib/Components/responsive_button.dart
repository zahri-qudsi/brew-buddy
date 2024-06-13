import 'package:flutter/material.dart';

class ResponsiveButton extends StatelessWidget {
  bool? isResponsive;
  double? width;
  final Widget child;

  ResponsiveButton({
    super.key,
    this.isResponsive,
    this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}
