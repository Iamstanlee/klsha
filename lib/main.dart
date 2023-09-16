import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klsha/app/recipe/bloc/recipe_bloc.dart';
import 'package:klsha/app/recipe/lunch_preference_page.dart';
import 'package:klsha/app/recipe/repository/recipe_repository.dart';
import 'package:klsha/app/recipe/repository/recipe_repository_impl.dart';
import 'package:klsha/core/constant.dart';
import 'package:klsha/core/design_system/theme.dart';
import 'package:klsha/core/http/http_client.dart';

final recipeRepository = RecipeRepository(
  http: HttpClient(
    dio: Dio(
      BaseOptions(
        baseUrl:
            'https://lb7u7svcm5.execute-api.ap-southeast-1.amazonaws.com/dev',
      ),
    ),
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const TechTask());
}

class TechTask extends StatelessWidget {
  const TechTask({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<IRecipeRepository>(
      create: (_) => recipeRepository,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstant.appName,
        theme: AppTheme.light,
        builder: (context, child) {
          return BlocProvider(
            create: (context) => RecipeBloc(
              recipeRepository: context.read<IRecipeRepository>(),
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: AppConstant.appTextScaleFactor,
              ),
              child: child!,
            ),
          );
        },
        home: const LunchPreferencePage(),
      ),
    );
  }
}
