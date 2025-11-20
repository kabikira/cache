import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/mock_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('モックJSONを取得しました')),
        );
      }
    } catch (e) {
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
