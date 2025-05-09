import 'dart:io';
import 'package:path/path.dart' as path;

void main() async {
  final projectDir = Directory('c:/Users/ray_a/OneDrive/Desktop/Projects/flt/learn/animations');
  final aiDir = Directory('${projectDir.path}/lib/screens/ai');
  
  if (!aiDir.existsSync()) {
    print('AI directory does not exist: ${aiDir.path}');
    return;
  }
  
  // Get all Dart files in the AI directory
  final aiFiles = await _getAllDartFiles(aiDir);
  print('Found ${aiFiles.length} Dart files in AI directory');
  
  // Get all Dart files in the project
  final allProjectFiles = await _getAllDartFiles(projectDir);
  print('Found ${allProjectFiles.length} Dart files in project');
  
  // Check which AI files are not imported anywhere
  final deadFiles = <File>[];
  
  for (final file in aiFiles) {
    final fileName = path.basename(file.path);
    final relativePath = path.relative(file.path, from: projectDir.path).replaceAll('\\', '/');
    
    bool isImported = false;
    
    for (final projectFile in allProjectFiles) {
      if (file.path == projectFile.path) continue; // Skip the file itself
      
      final content = await projectFile.readAsString();
      
      // Check for imports with various patterns
      if (content.contains("import 'package:animations/screens/ai/") ||
          content.contains('import "package:animations/screens/ai/') ||
          content.contains("import '$relativePath") ||
          content.contains('import "$relativePath') ||
          content.contains("part '$relativePath") ||
          content.contains('part "$relativePath')) {
        isImported = true;
        break;
      }
    }
    
    if (!isImported) {
      deadFiles.add(file);
    }
  }
  
  // Print results
  print('\nPotentially dead files:');
  if (deadFiles.isEmpty) {
    print('No dead files found in the AI directory.');
  } else {
    for (final file in deadFiles) {
      print('- ${path.relative(file.path, from: projectDir.path)}');
    }
    print('\n${deadFiles.length} potentially dead files found.');
  }
}

Future<List<File>> _getAllDartFiles(Directory dir) async {
  final files = <File>[];
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      files.add(entity);
    }
  }
  return files;
}
