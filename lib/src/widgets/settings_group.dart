import 'package:flutter/material.dart';

class MySettingsGroup extends StatefulWidget {
  const MySettingsGroup({Key? key, required this.title, required this.children})
      : super(key: key);
  final String title;
  final List<Widget> children;

  @override
  State<MySettingsGroup> createState() => _MySettingsGroupState();
}

class _MySettingsGroupState extends State<MySettingsGroup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: Text(widget.title),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.children,
          )
        ],
      ),
    );
  }
}
