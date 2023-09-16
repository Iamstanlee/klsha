import 'package:flutter/material.dart';
import 'package:klsha/core/design_system/color.dart';
import 'package:klsha/core/extensions/datetime.extension.dart';
import 'package:klsha/core/extensions/list.extension.dart';
import 'package:klsha/core/model/recipe.model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RecipePage extends StatelessWidget {
  final List<Recipe> recipes;
  final DateTime selectedDate;

  const RecipePage({
    required this.recipes,
    required this.selectedDate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes for ${selectedDate.formattedStr}'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            leading: Icon(
              PhosphorIcons.regular.forkKnife,
              color: AppColor.black,
            ),
            isThreeLine: true,
            title: Text(recipe.title),
            subtitle: Text(recipe.ingredients.seperatedByComma),
          );
        },
      ),
    );
  }
}
