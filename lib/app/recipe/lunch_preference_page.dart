import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klasha_assessment/app/recipe/bloc/recipe_bloc.dart';
import 'package:klasha_assessment/app/recipe/recipe_page.dart';
import 'package:klasha_assessment/core/design_system/color.dart';
import 'package:klasha_assessment/core/design_system/dimension.dart';
import 'package:klasha_assessment/core/design_system/typography.dart';
import 'package:klasha_assessment/core/design_system/widgets/button.dart';
import 'package:klasha_assessment/core/extensions/context.extension.dart';
import 'package:klasha_assessment/core/extensions/datetime.extension.dart';
import 'package:klasha_assessment/core/utils/snackbar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LunchPreferencePage extends StatefulWidget {
  const LunchPreferencePage({super.key});

  @override
  State<LunchPreferencePage> createState() => _LunchPreferencePageState();
}

class _LunchPreferencePageState extends State<LunchPreferencePage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(GetIngredientsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RecipeBloc, RecipeState>(
        listener: (context, state) {
          if (state.failedToLoadRecipe) {
            Snackbar.error(state.error).show(context);
          }
        },
        builder: (context, state) {
          if (state.type == PageStateType.loadingIngredients) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.black,
              ),
            );
          }

          if (state.failedToLoadIngredients) {
            return Padding(
              padding: const EdgeInsets.all(AppDimension.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!),
                  const SizedBox(height: AppDimension.md),
                  AppButton(
                    title: 'Retry',
                    onPressed: () {
                      context.read<RecipeBloc>().add(GetIngredientsEvent());
                    },
                  )
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(AppDimension.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimension.xl),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      PhosphorIcons.regular.forkKnife,
                      size: 32,
                    ),
                    const SizedBox(width: AppDimension.sm),
                    Expanded(
                      child: Text(
                        'Select preferred lunch date and pick ingredients to make a recipe',
                        style: AppTypography.h1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimension.xl),
                const Text('Lunch date'),
                const SizedBox(height: AppDimension.xs),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimension.xs),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: AppDimension.md),
                        Icon(PhosphorIcons.regular.calendarBlank),
                        const SizedBox(width: AppDimension.md),
                        Text(
                          _selectedDate.formattedStr,
                          style: AppTypography.body1.copyWith(),
                        ),
                        const Spacer(),
                        Icon(PhosphorIcons.regular.caretDown),
                        const SizedBox(width: AppDimension.sm),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimension.md),
                const Text('Ingredients'),
                const SizedBox(height: AppDimension.xs),
                Wrap(
                  spacing: AppDimension.xs,
                  runSpacing: AppDimension.xs,
                  children: [
                    for (final ingredient in state.ingredients)
                      FilterChip(
                        label: Text(ingredient.value.title),
                        selected: ingredient.isSelected,
                        disabledColor: AppColor.gray200,
                        onSelected: (value) {
                          setState(
                            () {
                              setState(() {
                                ingredient.isSelected = value;
                              });
                            },
                          );
                        },
                      ),
                  ],
                ),
                const Spacer(),
                AppButton(
                  title: 'Make recipe',
                  isLoading: state.type == PageStateType.loadingRecipe,
                  onPressed: () {
                    final selectedItems = state.ingredients
                        .where((e) => e.isSelected)
                        .map(
                          (e) => e.value.title,
                        )
                        .toList();

                    if (selectedItems.isEmpty) {
                      Snackbar.info(
                        'Please select at least one ingredient',
                      ).show(context);
                    } else {
                      context.read<RecipeBloc>().add(
                            MakeRecipeEvent(
                              selectedItems,
                              onDone: (recipes) {
                                context.push(
                                  RecipePage(
                                    recipes: recipes,
                                    selectedDate: _selectedDate,
                                  ),
                                );
                              },
                            ),
                          );
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
