import 'package:flutter/material.dart';
import 'text_group.dart';

class AutoSizeGroupBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, AutoSizeGroup autoSizeGroup)
  builder;

  const AutoSizeGroupBuilder({super.key, required this.builder});

  @override
  State<AutoSizeGroupBuilder> createState() => _AutoSizeGroupBuilderState();
}

class _AutoSizeGroupBuilderState extends State<AutoSizeGroupBuilder> {
  final _group = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _group);
  }
}
