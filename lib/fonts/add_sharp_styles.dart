// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() async {
  const inputPath = 'icons.json';
  const outputPath = 'icons_custom.json';

  final file = File(inputPath);
  if (!file.existsSync()) {
    print('❌ icons.json not found at $inputPath');
    return;
  }

  final content = await file.readAsString();
  final Map<String, dynamic> jsonData = jsonDecode(content);

  for (final icon in jsonData.entries) {
    final styles = List<String>.from(icon.value['styles'] ?? []);

    final additions = <String>[];

    if (styles.contains('solid')) additions.add('sharp-solid');
    if (styles.contains('regular')) additions.add('sharp-regular');
    if (styles.contains('light')) additions.add('sharp-light');
    if (styles.contains('thin')) additions.add('sharp-thin');
    if (styles.contains('duotone')) additions.add('sharp-duotone');

    final newStyles = {...styles, ...additions}.toList()..sort();
    icon.value['styles'] = newStyles;
  }

  final newJson = const JsonEncoder.withIndent('  ').convert(jsonData);
  await File(outputPath).writeAsString(newJson);

  print('✅ Updated icons saved to $outputPath');
}
