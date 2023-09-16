import 'package:klsha/app/recipe/repository/recipe_repository.dart';
import 'package:klsha/core/extensions/list.extension.dart';
import 'package:klsha/core/http/error.dart';
import 'package:klsha/core/http/http_client.dart';
import 'package:klsha/core/model/ingredient.model.dart';
import 'package:klsha/core/model/recipe.model.dart';
import 'package:klsha/core/utils/either.dart';

class RecipeRepository implements IRecipeRepository {
  final HttpClient _http;

  RecipeRepository({
    required HttpClient http,
  }) : _http = http;

  @override
  Future<Either<Failure, List<Ingredient>>> getIngredientsInFridge() async {
    final result = await runAsyncBlock(
      () => _http.get(
        '/ingredients',
      ),
    );

    return result.fold(
      (failure) => Left(failure),
      (ingredients) {
        return Right(
          List<Ingredient>.from(
            ingredients.map(
              (x) => Ingredient.fromMap(x),
            ),
          ),
        );
      },
    );
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipe(
    List<String> ingredients,
  ) async {
    final result = await runAsyncBlock(
      () => _http.get(
        '/recipes?ingredients=${ingredients.seperatedByComma}',
      ),
    );

    return result.fold(
      (failure) => Left(failure),
      (recipe) {
        return Right(
          List<Recipe>.from(
            recipe.map(
              (x) => Recipe.fromMap(x),
            ),
          ),
        );
      },
    );
  }
}
