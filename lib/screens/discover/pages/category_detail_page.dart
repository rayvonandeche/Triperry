import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:triperry/models/photo_response.dart';
import 'package:triperry/screens/discover/pages/item_detail_page.dart';

class CategoryDetailPage extends StatelessWidget {
  final String category;
  final List<PhotoResponse> photos;

  const CategoryDetailPage({
    super.key,
    required this.category,
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.97),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.90),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.80),
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: photos.isEmpty
            ? const Center(child: Text("No items available in this category"))
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ItemDetailPage(
                            photo: photo,
                            category: category,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.surface.withOpacity(0.8),
                            Theme.of(context).colorScheme.surface.withOpacity(0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                            spreadRadius: 0.5,
                          ),
                        ],
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: photo.src.medium,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  photo.alt,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "By ${photo.photographer}",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 20),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${(4.0 + (index % 10) / 10).toStringAsFixed(1)}",
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "(${100 + (index * 11)} reviews)",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: Theme.of(context).colorScheme.primary,
                                        size: 18,
                                      ),
                                      label: Text(
                                        "Save",
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
