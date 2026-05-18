import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/favorite_service.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  final String username;

  const FavoritePage({super.key, required this.username});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FavoriteService _favoriteService = FavoriteService();

  @override
  Widget build(BuildContext context) {
    final favorites = _favoriteService.getAllFavorites();

    if (favorites.isEmpty) {
      return const Center(child: Text('Belum ada makanan favorit, euy'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final meal = favorites[index];
        return _buildFavoriteTile(meal);
      },
    );
  }

  Widget _buildFavoriteTile(Meal meal) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          meal.strMealThumb,
          width: 72,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
        ),
      ),
      title: Text(
        meal.strMeal,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('${meal.strCategory} • ${meal.strCountry}'),
      trailing: IconButton(
        icon: const Icon(Icons.remove_circle_outline),
        onPressed: () async {
          await _favoriteService.removeFavorite(meal.idMeal);
          if (mounted) setState(() {});
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(idMeal: meal.idMeal)),
        ).then((_) => setState(() {}));
      },
    );
  }
}
