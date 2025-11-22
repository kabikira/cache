import 'package:flutter_riverpod/flutter_riverpod.dart';

/// モックJSON取得の成否フラグを管理するプロバイダ（コード生成なし）。
final fetchFlagProvider = NotifierProvider<FetchFlagNotifier, bool>(
  FetchFlagNotifier.new,
);

class FetchFlagNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setSuccess() => state = true;

  void setFailure() => state = false;
}
