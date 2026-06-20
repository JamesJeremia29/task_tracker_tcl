import 'package:flutter/material.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';
import 'package:task_tracker_tcl/utils/modifier/text_mod.dart';
import 'package:task_tracker_tcl/utils/constant/size_const.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: ColorConst.forestGreen,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: SizeConst.md),
            Text(message!, style: TextMod.body(color: ColorConst.sageGreen)),
          ],
        ],
      ),
    );
  }
}