import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klasha_assessment/app/recipe/repository/recipe_repository.dart';
import 'package:klasha_assessment/core/model/ingredient.model.dart';
import 'package:klasha_assessment/core/model/recipe.model.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final IRecipeRepository recipeRepository;

  RecipeBloc({required this.recipeRepository}) : super(const RecipeState()) {
    on<GetIngredientsEvent>(_onGetIngredients);
    on<MakeRecipeEvent>(_onGetRecipe);
  }

  void _onGetIngredients(
    GetIngredientsEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(state.copyWith(type: PageStateType.loadingIngredients));
    final response = await recipeRepository.getIngredientsInFridge();

    response.fold(
      (failure) => emit(
        state.copyWith(
          type: PageStateType.error,
          errorType: PageErrorType.failedToLoadIngredients,
          error: failure.message,
        ),
      ),
      (ingredients) {
        emit(
          state.copyWith(
            type: PageStateType.success,
            ingredients:
                ingredients.map((e) => SelectableIngredient(value: e)).toList(),
          ),
        );
      },
    );
  }

  void _onGetRecipe(
    MakeRecipeEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(state.copyWith(type: PageStateType.loadingRecipe));
    final response = await recipeRepository.getRecipe(event.ingredients);

    response.fold(
      (failure) => emit(
        state.copyWith(
          type: PageStateType.error,
          errorType: PageErrorType.failedToLoadRecipe,
          error: failure.message,
        ),
      ),
      (recipes) {
        emit(
          state.copyWith(
            type: PageStateType.success,
            recipes: recipes,
          ),
        );
        event.onDone(recipes);
      },
    );
  }
}
