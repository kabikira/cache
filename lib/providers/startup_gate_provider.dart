import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'flavor_provider.dart';

enum StartupStage { splash, debugMenu, ready }

class StartupGateNotifier extends Notifier<StartupStage> {
  @override
  StartupStage build() {
    // 実際のスプラッシュ画面を必ず最初に出す
    return StartupStage.splash;
  }

  void proceedAfterInit(Flavor flavor) {
    state = (flavor == Flavor.prod)
        ? StartupStage.ready
        : StartupStage.debugMenu;
  }

  void toReady() => state = StartupStage.ready;
}

final startupGateProvider =
    NotifierProvider<StartupGateNotifier, StartupStage>(
  StartupGateNotifier.new,
);
