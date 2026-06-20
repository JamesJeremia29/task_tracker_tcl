import 'package:flutter/material.dart';
import 'package:task_tracker_tcl/utils/constant/size_const.dart';

//Padding shortcuts
extension PaddingX on Widget {
  Widget padAll(double v)              => Padding(padding: EdgeInsets.all(v), child: this);
  Widget padH(double v)               => Padding(padding: EdgeInsets.symmetric(horizontal: v), child: this);
  Widget padV(double v)               => Padding(padding: EdgeInsets.symmetric(vertical: v), child: this);
  Widget padOnly({double l=0,double r=0,double t=0,double b=0}) =>
      Padding(padding: EdgeInsets.only(left:l, right:r, top:t, bottom:b), child: this);
  Widget padMd()                      => padAll(SizeConst.md);
  Widget padPage()                    => padH(SizeConst.md).padV(SizeConst.sm);
}

//SizedBox gaps
class Gap extends StatelessWidget {
  final double size;
  final bool horizontal;
  const Gap(this.size, {super.key, this.horizontal = false});
  const Gap.h(this.size, {super.key}) : horizontal = true;

  @override
  Widget build(BuildContext context) => horizontal
      ? SizedBox(width: size)
      : SizedBox(height: size);

  static const Widget xs  = SizedBox(height: SizeConst.xs);
  static const Widget sm  = SizedBox(height: SizeConst.sm);
  static const Widget md  = SizedBox(height: SizeConst.md);
  static const Widget lg  = SizedBox(height: SizeConst.lg);
  static const Widget xl  = SizedBox(height: SizeConst.xl);
}