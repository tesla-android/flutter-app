// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) {
    print('coverage/lcov.info not found');
    return;
  }

  final lines = file.readAsLinesSync();
  final Map<String, List<int>> coverage = {};
  String? currentFile;

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      currentFile = line.substring(3);
      if (currentFile.endsWith('.g.dart')) {
        currentFile = null;
        continue;
      }
      coverage[currentFile] = [0, 0]; // [hit, total]
    } else if (line.startsWith('DA:') && currentFile != null) {
      final parts = line.substring(3).split(',');
      final hits = int.parse(parts[1]);
      coverage[currentFile]![1]++; // total lines
      if (hits > 0) {
        coverage[currentFile]![0]++; // hit lines
      }
    }
  }

  int totalHits = 0;
  int totalLines = 0;

  print('Coverage Report:');
  print('----------------');

  final sortedFiles = coverage.keys.toList()..sort();

  for (final file in sortedFiles) {
    final stats = coverage[file]!;
    final hits = stats[0];
    final total = stats[1];
    totalHits += hits;
    totalLines += total;
    final percent = total > 0 ? (hits / total * 100).toStringAsFixed(1) : '0.0';
    
    // Filter out files that are 100% covered to focus on gaps
    if (hits < total) {
        print('$percent% ($hits/$total) - $file');
    }
  }

  print('----------------');
  final totalPercent = totalLines > 0 ? (totalHits / totalLines * 100).toStringAsFixed(1) : '0.0';
  print('Total Coverage: $totalPercent% ($totalHits/$totalLines)');
}
