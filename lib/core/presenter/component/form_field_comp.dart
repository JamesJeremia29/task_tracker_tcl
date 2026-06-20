import 'package:flutter/material.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';
import 'package:task_tracker_tcl/utils/modifier/text_mod.dart';
import 'package:task_tracker_tcl/utils/constant/size_const.dart';

class TaskFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const TaskFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextMod.label(color: ColorConst.forestGreen)),
        const SizedBox(height: SizeConst.xs),
        TextFormField(
          controller:      controller,
          validator:       validator,
          maxLines:        maxLines,
          focusNode:       focusNode,
          textInputAction: textInputAction,
          style:           TextMod.body(),
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
          decoration: InputDecoration(
            hintText:     hint,
            hintStyle:    TextMod.body(color: ColorConst.sageGreen.withOpacity(0.6)),
            counterText:  '',
          ),
        ),
      ],
    );
  }
}