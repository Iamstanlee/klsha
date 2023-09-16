import 'package:klasha_assessment/core/http/error.dart';
import 'package:klasha_assessment/core/model/ingredient.model.dart';
import 'package:klasha_assessment/core/model/recipe.model.dart';
import 'package:klasha_assessment/core/utils/either.dart';

abstract class IRecipeRepository {
  Future<Either<Failure, List<Ingredient>>> getIngredientsInFridge();

  Future<Either<Failure, List<Recipe>>> getRecipe(List<String> ingredients);
}
