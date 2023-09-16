part of 'recipe_bloc.dart';

enum PageStateType {
  loadingIngredients,
  loadingRecipe,
  error,
  success,
}

enum PageErrorType {
  failedToLoadIngredients,
  failedToLoadRecipe,
}

class RecipeState extends Equatable {
  final PageStateType type;
  final PageErrorType? errorType;
  final String? error;
  final List<SelectableIngredient> ingredients;
  final List<Recipe> recipes;

  const RecipeState({
    this.type = PageStateType.loadingIngredients,
    this.ingredients = const [],
    this.recipes = const [],
    this.error,
    this.errorType,
  });

  bool get failedToLoadIngredients =>
      type == PageStateType.error &&
      errorType == PageErrorType.failedToLoadIngredients;

  bool get failedToLoadRecipe =>
      type == PageStateType.error &&
      errorType == PageErrorType.failedToLoadRecipe;

  RecipeState copyWith({
    PageStateType? type,
    List<SelectableIngredient>? ingredients,
    List<Recipe>? recipes,
    String? error,
    PageErrorType? errorType,
  }) {
    return RecipeState(
      type: type ?? this.type,
      ingredients: ingredients ?? this.ingredients,
      recipes: recipes ?? this.recipes,
      error: error ?? this.error,
      errorType: errorType ?? this.errorType,
    );
  }

  @override
  List<Object?> get props => [
        type,
        ingredients,
        recipes,
        error,
        errorType,
      ];
}

class SelectableIngredient {
  final Ingredient value;
  bool isSelected;

  SelectableIngredient({
    required this.value,
    this.isSelected = false,
  });
}
