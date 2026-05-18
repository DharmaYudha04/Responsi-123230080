import 'package:flutter/material.dart';

class MenuItemData {
  final String title;
  final String description;
  final String endpoint;
  final String detailPath;
  final IconData icon;

  const MenuItemData({
    required this.title,
    required this.description,
    required this.endpoint,
    required this.detailPath,
    required this.icon,
  });
}

const List<MenuItemData> menuItems = [
  MenuItemData(
    title: 'News',
    description:
        'Dapatkan berita terbaru SpaceFlight dari berbagai sumber terpercaya dan buka website aslinya.',
    endpoint: 'articles',
    detailPath: 'articles',
    icon: Icons.newspaper_rounded,
  ),
  MenuItemData(
    title: 'Blog',
    description:
        'Blog berisi pembahasan peluncuran dan misi luar angkasa secara lebih mendalam.',
    endpoint: 'blogs',
    detailPath: 'blogs',
    icon: Icons.article_rounded,
  ),
  MenuItemData(
    title: 'Report',
    description:
        'Laporan data stasiun luar angkasa dan publikasi misi dari berbagai sumber.',
    endpoint: 'reports',
    detailPath: 'reports',
    icon: Icons.summarize_rounded,
  ),
];
