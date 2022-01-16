import 'package:flutter/material.dart';

class SnippetList extends StatefulWidget {
  final List<dynamic> snippetList;

  const SnippetList(this.snippetList, {Key? key}) : super(key: key);

  @override
  _SnippetListState createState() => _SnippetListState();
}

class _SnippetListState extends State<SnippetList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.snippetList.length,
      itemBuilder: (context, index) {
        return widget.snippetList[index].buildSnippet(context);
      },

    );
  }
}
