import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Flavor { dev, test, prod }

/// --dart-define=APP_FLAVOR=dev/test/prod で切り替え。デフォルトは prod。
const _flavorName = String.fromEnvironment('APP_FLAVOR', defaultValue: 'prod');

Flavor _parseFlavor() {
  switch (_flavorName.toLowerCase()) {
    case 'dev':
      return Flavor.dev;
    case 'test':
      return Flavor.test;
    default:
      return Flavor.prod;
  }
}

final flavorProvider = Provider<Flavor>((_) => _parseFlavor());
