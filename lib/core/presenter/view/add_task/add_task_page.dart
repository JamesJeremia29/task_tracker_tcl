import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';
import 'package:task_tracker_tcl/utils/constant/size_const.dart';
import 'package:task_tracker_tcl/utils/constant/prompt_const.dart';
import 'package:task_tracker_tcl/utils/modifier/button_mod.dart';
import 'package:task_tracker_tcl/utils/modifier/snackbar_mod.dart';
import 'package:task_tracker_tcl/utils/modifier/text_mod.dart';
import 'package:task_tracker_tcl/core/feature/task_repo_feat.dart';
import 'package:task_tracker_tcl/core/presenter/component/form_field_comp.dart';
import 'add_task_cubit.dart';
import 'add_task_state.dart';

class AddTaskPage extends StatelessWidget {
  final TaskRepository repository;
  const AddTaskPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTaskCubit(repository),
      child: const _AddTaskView(),
    );
  }
}

class _AddTaskView extends StatefulWidget {
  const _AddTaskView();

  @override
  State<_AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<_AddTaskView> {
  final _formKey    = GlobalKey<FormState>();
  final _titleCtrl  = TextEditingController();
  final _descCtrl   = TextEditingController();
  final _titleFocus = FocusNode();
  final _descFocus  = FocusNode();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _titleFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AddTaskCubit>().addTask(
        title:       _titleCtrl.text,
        description: _descCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddTaskCubit, AddTaskState>(
      listener: (context, state) {
        if (state is AddTaskSuccess) {
          AppSnackbar.success(context, PromptConst.addTask);
          Navigator.pop(context);
        }
        if (state is AddTaskError) {
          AppSnackbar.error(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(PromptConst.addTask,
              style: TextMod.h2(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(SizeConst.md),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: SizeConst.sm),

                  //Page header
                  Text('New Task',
                      style: TextMod.h1(color: ColorConst.forestGreen)),
                  const SizedBox(height: SizeConst.xs),
                  Text(
                    'Fill in the details below to add a task.',
                    style: TextMod.body(color: ColorConst.sageGreen),
                  ),

                  const SizedBox(height: SizeConst.xl),

                  //Title field
                  TaskFormField(
                    label:           PromptConst.titleLabel,
                    hint:            PromptConst.titleHint,
                    controller:      _titleCtrl,
                    focusNode:       _titleFocus,
                    nextFocusNode:   _descFocus,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return PromptConst.titleRequired;
                      }
                      if (v.trim().length < 3) {
                        return PromptConst.titleTooShort;
                      }
                      if (v.trim().length > 100) {
                        return PromptConst.titleTooLong;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: SizeConst.lg),

                  //Description field
                  TaskFormField(
                    label:           PromptConst.descriptionLabel,
                    hint:            PromptConst.descriptionHint,
                    controller:      _descCtrl,
                    focusNode:       _descFocus,
                    maxLines:        4,
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return PromptConst.descriptionRequired;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: SizeConst.xxl),

                  //Submit button
                  BlocBuilder<AddTaskCubit, AddTaskState>(
                    builder: (context, state) => AppButton(
                      label:     PromptConst.save,
                      icon:      Icons.add_task_rounded,
                      isLoading: state is AddTaskLoading,
                      onPressed: state is AddTaskLoading
                          ? null
                          : () => _submit(context),
                    ),
                  ),

                  const SizedBox(height: SizeConst.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}