import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../models/space_item.dart';
import '../services/space_api_service.dart';
import 'detail_page.dart';

class ListPage extends StatefulWidget {
  final MenuItemData menu;

  const ListPage({super.key, required this.menu});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final SpaceApiService _apiService = SpaceApiService();
  late Future<List<SpaceItem>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = _apiService.fetchItems(widget.menu.endpoint);
  }

  Future<void> _refresh() async {
    setState(() {
      _futureItems = _apiService.fetchItems(widget.menu.endpoint);
    });
    await _futureItems;
  }

  String get _title {
    switch (widget.menu.title) {
      case 'News':
        return 'Berita Terkini';
      case 'Blog':
        return 'Blog Terkini';
      default:
        return 'Report Terkini';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: FutureBuilder<List<SpaceItem>>(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ErrorView(
              message: snapshot.error.toString(),
              onRetry: _refresh,
            );
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Data tidak ditemukan.'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _SpaceItemCard(
                  item: item,
                  menu: widget.menu,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _SpaceItemCard extends StatelessWidget {
  final SpaceItem item;
  final MenuItemData menu;

  const _SpaceItemCard({required this.item, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(
                menu: menu,
                initialItem: item,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: item.imageUrl.isEmpty
                      ? const ColoredBox(
                          color: Colors.white,
                          child: Center(
                            child: Icon(Icons.image_not_supported_rounded, size: 48),
                          ),
                        )
                      : Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return const ColoredBox(
                              color: Colors.white,
                              child: Center(
                                child: Icon(Icons.broken_image_rounded, size: 48),
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                item.newsSite,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.formattedDate,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64),
            const SizedBox(height: 16),
            Text(
              'Terjadi kesalahan saat memuat data.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
