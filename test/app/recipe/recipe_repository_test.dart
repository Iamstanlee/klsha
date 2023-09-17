import 'package:flutter_test/flutter_test.dart';
import 'package:klsha/app/recipe/repository/recipe_repository.dart';
import 'package:klsha/app/recipe/repository/recipe_repository_impl.dart';
import 'package:klsha/core/http/http_client.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late HttpClient httpClient;
  late IRecipeRepository recipeRepository;

  setUp(() {
    httpClient = MockHttpClient();
    recipeRepository = RecipeRepository(http: httpClient);
  });

  group('RecipeRepository.getIngredientsInFridge', () {
    test('should return list of ingredients', () async {
      when(() => httpClient.get(any())).thenAnswer((_) async => []);
      final response = await recipeRepository.getIngredientsInFridge();
      expect(response.isRight, true);
    });

    test('should return error when request fail', () async {
      when(() => httpClient.get(any())).thenThrow('error');
      final response = await recipeRepository.getIngredientsInFridge();
      expect(response.isLeft, true);
    });
  });

  group('RecipeRepository.getRecipe', () {
    test('should return list of recipes', () async {
      when(() => httpClient.get(any())).thenAnswer((_) async => []);
      final response = await recipeRepository.getRecipe([]);
      expect(response.isRight, true);
    });

    test('should return error when request fail', () async {
      when(() => httpClient.get(any())).thenThrow('error');
      final response = await recipeRepository.getRecipe([]);
      expect(response.isLeft, true);
    });
  });
}
