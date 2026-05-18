import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/menu_item.dart';
import '../models/space_item.dart';
import '../services/space_api_service.dart';

class DetailPage extends StatefulWidget {
  final MenuItemData menu;
  final SpaceItem initialItem;

  const DetailPage({
    super.key,
    required this.menu,
    required this.initialItem,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final SpaceApiService _apiService = SpaceApiService();
  late Future<SpaceItem> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = _apiService.fetchDetail(
      detailPath: widget.menu.detailPath,
      id: widget.initialItem.id,
    );
  }

  String get _title => '${widget.menu.title} Detail';

  Future<void> _openWebsite(String url) async {
    if (url.isEmpty) {
      _showSnackBar('URL tidak tersedia.');
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showSnackBar('URL tidak valid.');
      return;
    }

    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!success && mounted) {
      _showSnackBar('Tidak bisa membuka website.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpaceItem>(
      future: _futureDetail,
      builder: (context, snapshot) {
        final item = snapshot.data ?? widget.initialItem;

        return Scaffold(
          appBar: AppBar(title: Text(_title)),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openWebsite(item.url),
            icon: const Icon(Icons.open_in_browser_rounded),
            label: const Text('Buka Web'),
          ),
          body: Builder(
            builder: (context) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError && snapshot.data == null) {
                return _DetailErrorView(
                  message: snapshot.error.toString(),
                  item: widget.initialItem,
                );
              }

              return _DetailContent(item: item);
            },
          ),
        );
      },
    );
  }
}

class _DetailContent extends StatelessWidget {
  final SpaceItem item;

  const _DetailContent({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 90),
      children: [
        if (item.imageUrl.isNotEmpty)
          Image.network(
            item.imageUrl,
            height: 260,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return const SizedBox(
                height: 220,
                child: Center(child: Icon(Icons.broken_image_rounded, size: 60)),
              );
            },
          )
        else
          const SizedBox(
            height: 220,
            child: Center(child: Icon(Icons.image_not_supported_rounded, size: 60)),
          ),
        Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.public_rounded, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.newsSite,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text(item.formattedDate),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                item.summary,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.55,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailErrorView extends StatelessWidget {
  final String message;
  final SpaceItem item;

  const _DetailErrorView({required this.message, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 90),
      children: [
        const SizedBox(height: 28),
        const Icon(Icons.error_outline_rounded, size: 64),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Detail gagal dimuat, menampilkan data ringkas dari list.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        if (item.imageUrl.isNotEmpty)
          Image.network(
            item.imageUrl,
            height: 220,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(item.newsSite),
              const SizedBox(height: 6),
              Text(item.formattedDate),
              const SizedBox(height: 18),
              Text(
                item.summary,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.55),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
