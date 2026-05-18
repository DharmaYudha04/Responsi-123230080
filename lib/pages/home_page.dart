import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';
import '../services/favorite_service.dart';
import '../services/meal_api_service.dart';
import 'detail_page.dart';
import 'favorite_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MealApiService _apiService = MealApiService();
  final FavoriteService _favoriteService = FavoriteService();
  final List<String> _categories = ['Beef', 'Chicken', 'Pork'];

  int _selectedIndex = 0;
  String _selectedCategory = 'Beef';
  late Future<List<Meal>> _mealFuture;

  @override
  void initState() {
    super.initState();
    _mealFuture = _apiService.getMealsByCategory(_selectedCategory);
  }

  void _changeCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _mealFuture = _apiService.getMealsByCategory(category);
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildFoodPage(),
      FavoritePage(username: widget.username),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, ${widget.username}!'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Makanan'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
        ],
      ),
    );
  }

  Widget _buildFoodPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Lihat-lihat makanannya, euy!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: _categories.map((category) {
              final selected = category == _selectedCategory;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Center(child: Text(category)),
                    selected: selected,
                    onSelected: (_) => _changeCategory(category),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder<List<Meal>>(
            future: _mealFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final meals = snapshot.data ?? [];
              if (meals.isEmpty) {
                return const Center(child: Text('Harusnya ada makanan disini, cok!'));
              }
              return ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) => _buildMealTile(meals[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMealTile(Meal meal) {
    final isFavorite = _favoriteService.isFavorite(meal.idMeal);
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
      subtitle: Text(meal.strCountry),
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        color: isFavorite ? Colors.red : null,
        onPressed: () async {
          await _favoriteService.toggleFavorite(meal);
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
