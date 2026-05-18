import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_detail.dart';
import '../services/meal_api_service.dart';

class DetailPage extends StatefulWidget {
  final String idMeal;

  const DetailPage({super.key, required this.idMeal});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final MealApiService _apiService = MealApiService();
  late Future<MealDetail> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _apiService.getMealDetail(widget.idMeal);
  }

  Future<void> _openSource(String source) async {
    if (source.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sumber tidak tersedia')),
      );
      return;
    }

    final uri = Uri.parse(source);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka sumber')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF4FF),
      appBar: AppBar(title: const Text('Detail Makanan')),
      body: FutureBuilder<MealDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final meal = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    meal.strMealThumb,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  meal.strMeal,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _infoText('Kategori', meal.strCategory),
                _infoText('Negara/Daerah', meal.strArea),
                const SizedBox(height: 12),
                const Text(
                  'Cara Membuat (Bahasa Enggres)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  meal.strInstructions,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(height: 1.4),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sumber',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                SelectableText(meal.strSource.isEmpty ? '-' : meal.strSource),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openSource(meal.strSource),
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('Buka Sumber'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
