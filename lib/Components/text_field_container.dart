import 'package:brew_buddy/const.dart';
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: 360,
      decoration: BoxDecoration(
        color: textFieldContainer,
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(
        //   color: Colors.black,
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     spreadRadius: 2,
        //     blurRadius: 4,
        //     offset: const Offset(1, 4), // changes position of shadow
        //   ),
        // ],
      ),
      child: child,
    );
  }
}
