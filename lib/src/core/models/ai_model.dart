import 'package:equatable/equatable.dart';

class AIModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String downloadUrl;
  final String size;
  final String localPath;
  final bool isDownloaded;
  final bool isDownloading;
  final double downloadProgress;

  const AIModel({
    required this.id,
    required this.name,
    required this.description,
    required this.downloadUrl,
    required this.size,
    required this.localPath,
    required this.isDownloaded,
    required this.isDownloading,
    required this.downloadProgress,
  });

  AIModel copyWith({
    String? id,
    String? name,
    String? description,
    String? downloadUrl,
    String? size,
    String? localPath,
    bool? isDownloaded,
    bool? isDownloading,
    double? downloadProgress,
  }) {
    return AIModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      size: size ?? this.size,
      localPath: localPath ?? this.localPath,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    downloadUrl,
    size,
    localPath,
    isDownloaded,
    isDownloading,
    downloadProgress,
  ];
}
