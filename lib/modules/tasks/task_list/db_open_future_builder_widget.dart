import 'package:flutter/material.dart';
import 'package:todo_own/shared/network/local/sqflite_utils.dart';

class DbOpenFutureBuilder extends StatefulWidget {
  final SqfliteUtils sqfliteUtils;
  Widget Function(BuildContext, AsyncSnapshot<void>) builder;

  DbOpenFutureBuilder({required this.sqfliteUtils, required this.builder});

  @override
  State<DbOpenFutureBuilder> createState() => _DbOpenFutureBuilderState();
}

class _DbOpenFutureBuilderState extends State<DbOpenFutureBuilder> {
  Future? open;

  @override
  void initState() {
    super.initState();
    open = widget.sqfliteUtils.open();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: open, builder: widget.builder);
  }
}
