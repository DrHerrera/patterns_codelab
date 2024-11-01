import 'package:flutter/material.dart';

import 'data.dart';

void main() {
  runApp(const DocumentApp());
}

class DocumentApp extends StatelessWidget {
  const DocumentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: DocumentScreen(
        document: Document(),
      ),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final Document document;

  const DocumentScreen({
    required this.document,
    super.key,
  });
  String formatDate(DateTime dateTime) {
    final today = DateTime.now();
    final difference = dateTime.difference(today);

    return switch (difference) {
      Duration(inDays: 0) => 'today',
      Duration(inDays: 1) => 'tomorrow',
      Duration(inDays: -1) => 'yesterday',
      Duration(inDays: final days) when days > 7 =>
        '${days ~/ 7} weeks from now', // Add from here
      Duration(inDays: final days) when days < -7 =>
        '${days.abs() ~/ 7} weeks ago', // to here.
      Duration(inDays: final days, isNegative: true) =>
        '${days.abs()} days ago',
      Duration(inDays: final days) => '$days days from now',
    };
  }

  @override
  Widget build(BuildContext context) {
    // final metadataRecord = document.metadata;
    // final (title, modified: modified) = document.metadata;
    final (title, :modified) =
        document.metadata; //esta es una forma abreviada de la anterior
    final formattedModifiedDate = formatDate(modified);
    final blocks = document.getBlocks(); // Add this line
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title),
            const SizedBox(
              width: 10,
            ),
            // Text(metadataRecord.$1),
          ],
        ),
      ),
      body: Column(
        children: [
          Text('Last modified: $formattedModifiedDate'), // Modify from here
          Expanded(
            child: ListView.builder(
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                return BlockWidget(block: blocks[index]);
              },
            ),
          ), // to here.
        ],
      ),
    );
  }
}

class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({
    required this.block,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: switch (block) {
        HeaderBlock(:final text) => Text(
            text,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ParagraphBlock(:final text) => Text(text),
        CheckboxBlock(:final text, :final isChecked) => Row(
            children: [
              Checkbox(value: isChecked, onChanged: (_) {}),
              Text(text),
            ],
          ),
      },
    );
  }
}
