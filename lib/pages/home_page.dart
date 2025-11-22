import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/fetch_flag_provider.dart';
import '../services/mock_api.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final MockApi _api = MockApi();
  bool _loading = false;
  String? _lastResponse;

  Future<void> _handleFetch() async {
    setState(() {
      _loading = true;
      _lastResponse = null;
    });
    try {
      final data = await _api.fetchDummyData();
      setState(() {
        _lastResponse = data.toString();
      });
      ref.read(fetchFlagProvider.notifier).setSuccess();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('モックJSONを取得しました')),
        );
      }
    } catch (e) {
      ref.read(fetchFlagProvider.notifier).setFailure();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('取得に失敗しました: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fetched = ref.watch(fetchFlagProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('メイン画面'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('GoRouterで画面遷移を試します'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/detail'),
              child: const Text('詳細へ移動'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push('/modal'),
              child: const Text('モーダルを開く'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loading ? null : _handleFetch,
              icon: _loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download),
              label: Text(_loading ? '取得中...' : 'モックJSONを取得'),
            ),
            const SizedBox(height: 8),
            Text('取得フラグ: ${fetched ? 'TRUE' : 'FALSE'}'),
            if (_lastResponse != null) ...[
              const SizedBox(height: 12),
              Text(
                _lastResponse!,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
