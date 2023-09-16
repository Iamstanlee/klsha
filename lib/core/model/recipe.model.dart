class Recipe {
  String title;
  List<String> ingredients;

  Recipe(this.title, this.ingredients);

  factory Recipe.fromMap(Map<String, dynamic> json) {
    return Recipe(
      json['title'],
      List<String>.from(json['ingredients']),
    );
  }
}
