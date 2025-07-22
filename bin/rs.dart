import 'dart:io';

void main() async {
  print('\x1B[33m🔧 Rahul Structure CLI Tool (rs)\x1B[0m\n');
  print('📁 Are you creating your project structure?');
  print('  1️⃣  Clean Architecture');
  print('  2️⃣  MVVM Architecture');
  print('  3️⃣  Rahul Architecture (custom)');
  stdout.write('\n👉 Please enter your choice (1/2/3): ');

  final input = stdin.readLineSync();

  switch (input) {
    case '1':
      print('\n⏬ Downloading and generating Clean Architecture...');
      await createCleanArchitecture();
      break;
    case '2':
      print('\n⏬ Downloading and generating MVVM Architecture...');
      await createMVVMArchitecture();
      break;
    case '3':
      print('\n⏬ Downloading and generating Rahul Architecture...');
      await createRahulArchitecture();
      break;
    default:
      print('\n❌ Invalid choice. Please run `rs` again and choose 1, 2, or 3.');
      return;
  }

  print('\n✅ \x1B[32mStructure successfully generated!\x1B[0m');
}

Future<void> createCleanArchitecture() async {
  final paths = [
    'lib/core',
    'lib/features/auth/data',
    'lib/features/auth/domain',
    'lib/features/auth/presentation',
  ];
  for (var path in paths) {
    await Directory(path).create(recursive: true);
    print('📂 Created $path');
  }
}

Future<void> createMVVMArchitecture() async {
  final paths = [
    'lib/models',
    'lib/views',
    'lib/view_models',
    'lib/services',
  ];
  for (var path in paths) {
    await Directory(path).create(recursive: true);
    print('📂 Created $path');
  }
}

Future<void> createRahulArchitecture() async {
  final paths = [
    'lib/app/constants',
    'lib/app/modules/home/controllers',
    'lib/app/modules/home/views',
    'lib/app/routes',
    'lib/app/shared',
  ];
  for (var path in paths) {
    await Directory(path).create(recursive: true);
    print('📂 Created $path');
  }
}
