import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klsha/app/recipe/bloc/recipe_bloc.dart';
import 'package:klsha/app/recipe/repository/recipe_repository_impl.dart';
import 'package:klsha/core/http/error.dart';
import 'package:klsha/core/utils/either.dart';
import 'package:mocktail/mocktail.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}

void main() {
  late RecipeRepository recipeRepository;
  late RecipeBloc recipeBloc;
  setUp(() {
    recipeRepository = MockRecipeRepository();
    recipeBloc = RecipeBloc(recipeRepository: recipeRepository);
  });

  group('RecipeBloc._onGetIngredients', () {
    test('initial state should be loadingIngredients', () {
      expect(recipeBloc.state.type, PageStateType.loadingIngredients);
    });

    blocTest<RecipeBloc, RecipeState>(
      'should emit [loadingIngredients, success] when success',
      setUp: () {
        when(() => recipeRepository.getIngredientsInFridge()).thenAnswer(
          (_) async => const Right([]),
        );
      },
      build: () => recipeBloc,
      act: (bloc) => bloc.add(GetIngredientsEvent()),
      expect: () => const <RecipeState>[
        RecipeState(type: PageStateType.loadingIngredients),
        RecipeState(type: PageStateType.success),
      ],
    );

    blocTest<RecipeBloc, RecipeState>(
      'should emit [loadingIngredients, error] when failed',
      setUp: () {
        when(() => recipeRepository.getIngredientsInFridge()).thenAnswer(
          (_) async => Left(
            Failure.fromStr("error"),
          ),
        );
      },
      build: () => recipeBloc,
      act: (bloc) => bloc.add(GetIngredientsEvent()),
      expect: () => const <RecipeState>[
        RecipeState(type: PageStateType.loadingIngredients),
        RecipeState(
          type: PageStateType.error,
          errorType: PageErrorType.failedToLoadIngredients,
          error: "error",
        ),
      ],
    );
  });

  group('RecipeBloc._onGetRecipe', () {
    blocTest<RecipeBloc, RecipeState>(
      'should emit [loadingRecipe, success] when success',
      setUp: () {
        when(() => recipeRepository.getRecipe(any())).thenAnswer(
          (_) async => const Right([]),
        );
      },
      build: () => recipeBloc,
      act: (bloc) => bloc.add(
        MakeRecipeEvent(const ['tomato'], onDone: (value) {}),
      ),
      expect: () => const <RecipeState>[
        RecipeState(type: PageStateType.loadingRecipe),
        RecipeState(type: PageStateType.success),
      ],
    );

    blocTest<RecipeBloc, RecipeState>(
      'should emit [loadingRecipe, error] when failed',
      setUp: () {
        when(() => recipeRepository.getRecipe(any())).thenAnswer(
          (_) async => Left(
            Failure.fromStr("error"),
          ),
        );
      },
      build: () => recipeBloc,
      act: (bloc) => bloc.add(
        MakeRecipeEvent(const ['tomato'], onDone: (value) {}),
      ),
      expect: () => const <RecipeState>[
        RecipeState(type: PageStateType.loadingRecipe),
        RecipeState(
          type: PageStateType.error,
          errorType: PageErrorType.failedToLoadRecipe,
          error: "error",
        ),
      ],
    );
  });
}
