part of 'model_bloc.dart';

abstract class ModelState extends Equatable {
  const ModelState();
  
  @override
  List<Object> get props => [];
}

class ModelInitial extends ModelState {
  const ModelInitial();
}

class ModelLoading extends ModelState {
  const ModelLoading();
}

class ModelLoaded extends ModelState {
  final List<AIModel> models;

  const ModelLoaded({required this.models});

  @override
  List<Object> get props => [models];

  ModelLoaded copyWith({
    List<AIModel>? models,
  }) {
    return ModelLoaded(
      models: models ?? this.models,
    );
  }
}

class ModelError extends ModelState {
  final String message;

  const ModelError(this.message);

  @override
  List<Object> get props => [message];
}
