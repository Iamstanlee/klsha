class Ingredient {
  String title;
  DateTime? useBy;

  Ingredient(this.title, this.useBy);

  factory Ingredient.fromMap(Map<String, dynamic> json) {
    return Ingredient(
      json['title'],
      json['use-by'] != null ? DateTime.parse(json['use-by']) : null,
    );
  }
}
