import 'package:klsha/core/http/error.dart';
import 'package:klsha/core/model/ingredient.model.dart';
import 'package:klsha/core/model/recipe.model.dart';
import 'package:klsha/core/utils/either.dart';

abstract class IRecipeRepository {
  Future<Either<Failure, List<Ingredient>>> getIngredientsInFridge();

  Future<Either<Failure, List<Recipe>>> getRecipe(List<String> ingredients);
}
