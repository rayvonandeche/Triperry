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
  
  const VideoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.thumbnailUrl,
    required this.uploadedBy,
    required this.duration,
    required this.views,
    required this.uploadDate,
    this.tags = const [],
  });
  
  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
      uploadedBy: json['uploadedBy'],
      duration: json['duration'],
      views: json['views'],
      uploadDate: DateTime.parse(json['uploadDate']),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'uploadedBy': uploadedBy,
      'duration': duration,
      'views': views,
      'uploadDate': uploadDate.toIso8601String(),
      'tags': tags,
    };
  }
  
  /// Format duration as MM:SS
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  /// Get formatted view count (e.g. 1.2M, 450K, etc.)
  String get formattedViewCount {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return views.toString();
    }
  }
}