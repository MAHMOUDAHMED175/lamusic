import 'package:flutter/material.dart';
import 'package:lamusic/core/utils/colors.dart';

class KBackground extends StatelessWidget {
  const KBackground({
    Key? key,
    required this.child,
     this.fade = true,
  }) : super(key: key);
  final Widget child;
  final bool fade;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: ColorsApp.blackColor,
        image: const DecorationImage(
          image:  AssetImage('assets/images/msc.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: child,
    );
  }
}
