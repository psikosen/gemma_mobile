part of 'model_bloc.dart';

abstract class ModelEvent extends Equatable {
  const ModelEvent();

  @override
  List<Object> get props => [];
}

class LoadModels extends ModelEvent {
  const LoadModels();
}

class DownloadModel extends ModelEvent {
  final AIModel model;

  const DownloadModel(this.model);

  @override
  List<Object> get props => [model];
}

class UpdateDownloadProgress extends ModelEvent {
  final String modelId;
  final double progress;

  const UpdateDownloadProgress({
    required this.modelId,
    required this.progress,
  });

  @override
  List<Object> get props => [modelId, progress];
}

class DeleteModel extends ModelEvent {
  final AIModel model;

  const DeleteModel(this.model);

  @override
  List<Object> get props => [model];
}
