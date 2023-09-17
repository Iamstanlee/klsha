// coverage:ignore-file
part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object?> get props => [];
}

class GetIngredientsEvent extends RecipeEvent {}

class MakeRecipeEvent extends RecipeEvent {
  final List<String> ingredients;
  final ValueChanged<List<Recipe>> onDone;

  const MakeRecipeEvent(this.ingredients, {required this.onDone});

  @override
  List<Object?> get props => [ingredients];
}
