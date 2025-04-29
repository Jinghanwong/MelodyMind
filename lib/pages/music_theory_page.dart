import 'package:flutter/material.dart';
import 'package:fyp/pages/accidentals.dart';
import 'package:fyp/pages/clefs.dart';
import 'package:fyp/pages/key_signatures.dart';
import 'package:fyp/pages/time_names.dart';
import 'package:fyp/pages/time_signatures.dart';

class MusicTheoryPage extends StatelessWidget {
  final List<CategoryItem> categories = [
    CategoryItem(
      title: 'Time Names',
      icon: Icons.music_note,
      description: 'Learn about musical time name and their values',
      gradient: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
    ),
    CategoryItem(
      title: 'Time Signatures',
      icon: Icons.piano,
      description: 'Understand the musical time signatures',
      gradient: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
    ),
    CategoryItem(
      title: 'Clefs',
      icon: Icons.library_music,
      description: 'Master different types of musical clefs',
      gradient: [Color(0xFFFF9A9E), Color(0xFFFECAA6)],
    ),
    CategoryItem(
      title: 'Accidentals',
      icon: Icons.tag,
      description: 'Learn about sharps, flats, and naturals',
      gradient: [Color(0xFFFBC2EB), Color(0xFFA6C1EE)],
    ),
    CategoryItem(
      title: 'Key Signatures',
      icon: Icons.queue_music,
      description: 'Explore musical keys and scales',
      gradient: [Color(0xFFA6C1EE), Color(0xFFFFCDB2)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Music Theory',
                style: TextStyle(
                  color: Color(0xFF753027),
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFF0F5),
                      Color(0xFFFFE4E1),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.music_note,
                    size: 80,
                    color: Color(0xFF753027).withOpacity(0.3),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF753027)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildCategoryCard(categories[index], context),
                  );
                },
                childCount: categories.length,
              ),
            ),
          ),
          // Add extra padding at the bottom
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CategoryItem category, BuildContext context) {
    return Hero(
      tag: category.title,
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 120,
          child: InkWell(
            onTap: () {
              if (category.title == 'Time Names') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimeNamesPage(),
                  ),
                );
              } else if (category.title == 'Time Signatures') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimeSignaturesPage(),
                  ),
                );
              } else if (category.title == 'Clefs') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClefsPage(),
                  ),
                );
              } else if (category.title == 'Accidentals') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccidentalsPage(),
                  ),
                );
              } else if (category.title == 'Key Signatures') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KeySignaturesPage(),
                  ),
                );
              } 
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: category.gradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              category.icon,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  category.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category.description,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                    height: 1.2, // Added line height
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white.withOpacity(0.8),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItem {
  final String title;
  final IconData icon;
  final String description;
  final List<Color> gradient;

  CategoryItem({
    required this.title,
    required this.icon,
    required this.description,
    required this.gradient,
  });
}
