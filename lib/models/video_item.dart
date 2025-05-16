class VideoItem {
  final int id;
  final String title;
  final String description;
  final String url;
  final String thumbnailUrl;
  final String uploadedBy;
  final int duration; // in seconds
  final int views;
  final DateTime uploadDate;
  final List<String> tags;

  VideoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.thumbnailUrl,
    required this.uploadedBy,
    required this.duration,
    required this.views,
    required this.uploadDate,
    required this.tags,
  });
}