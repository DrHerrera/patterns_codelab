import 'dart:convert';

import 'package:flutter/material.dart';

class Document {
  final Map<String, Object?> _json;
  Document() : _json = jsonDecode(documentJson);
  (String, {bool isChecked, DateTime modified}) get metadata {
    if (_json // Modify from here...
        case {
          'metadata': {
            'title': String title,
            'modified': String localModified,
          }
        }) {
      return (
        title,
        modified: DateTime.parse(localModified),
        isChecked: true,
      );
    } else {
      throw const FormatException('Unexpected JSON');
    }
  } // to here.

  List<Block> getBlocks() {
    // Add from here...
    if (_json case {'blocks': List blocksJson}) {
      return [for (final blockJson in blocksJson) Block.fromJson(blockJson)];
    } else {
      throw const FormatException('Unexpected JSON format');
    }
  } // to here.

/*    if (_json.containsKey('metadata')) {             // Modify from here...
      final metadataJson = _json['metadata'];          //Este segmento se usa para usar patrones
      if (metadataJson is Map) {                       // sin coincidencias para tomar decisiones
        final title = metadataJson['title'] as String; //sobre esos patrones.
        final localModified =
            DateTime.parse(metadataJson['modified'] as String);
        return (title, modified: localModified);
      }
    }
    throw const FormatException('Unexpected JSON');     // to here. */

  // const title = 'My Document';   //esta fue la prueba inicial
  // final now = DateTime.now();               //
  // return (title, modified: now);            //
}

sealed class Block {
  Block();

  factory Block.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {'type': 'h1', 'text': String text} => HeaderBlock(text),
      {'type': 'p', 'text': String text} => ParagraphBlock(text),
      {'type': 'checkbox', 'text': String text, 'checked': bool checked} =>
        CheckboxBlock(text, checked),
      _ => throw const FormatException('Unexpected JSON format'),
    };
  }
}

class HeaderBlock extends Block {
  final String text;
  HeaderBlock(this.text);
}

class ParagraphBlock extends Block {
  final String text;
  ParagraphBlock(this.text);
}

class CheckboxBlock extends Block {
  final String text;
  final bool isChecked;
  CheckboxBlock(this.text, this.isChecked);
}

const documentJson = '''
{
  "metadata": {
    "title": "My Document", 
    "modified": "2023-05-10"
  },
  "blocks": [
    {
      "type": "h1",
      "text": "Chapter 1"
    },
    {
      "type": "p",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "type": "checkbox",
      "checked": false,
      "text": "Learn Dart 3"
    }
  ]
}
''';
