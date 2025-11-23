import 'package:flutter/material.dart';

class TabExamplePage extends StatelessWidget {
  const TabExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タブの例'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _InfoCard(
            title: 'サンプルカード 1',
            description: 'タブブランチで表示するダミーコンテンツです。',
          ),
          _InfoCard(
            title: 'サンプルカード 2',
            description: '共通ボトムバーの挙動を確認できます。',
          ),
          _InfoCard(
            title: 'サンプルカード 3',
            description: '好きなウィジェットに差し替えてください。',
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        leading: const Icon(Icons.star_outline),
      ),
    );
  }
}
