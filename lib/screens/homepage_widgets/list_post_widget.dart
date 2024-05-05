import 'package:flutter/material.dart';

class ListPostWidget extends StatefulWidget {
  const ListPostWidget({super.key});

  @override
  State<ListPostWidget> createState() => _ListPostWidgetState();
}

class _ListPostWidgetState extends State<ListPostWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Post'),
      ),
      body: const Center(
        child: Text('List Post'),
      ),
    );
  }
}
