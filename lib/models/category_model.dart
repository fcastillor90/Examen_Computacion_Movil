class Category {
  final int? id;
  final String name;
  final String? state;

  Category({
    this.id,
    required this.name,
    this.state = "Activa"
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['category_id'],
      name: json['category_name'],
      state: json['category_state'] ?? "Activa"
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['category_id'] = id;
    }
    data['category_name'] = name;
    if (state != null) {
      data['category_state'] = state;
    }
    return data;
  }

  // For adding a new category (without ID)
  Map<String, dynamic> toAddJson() {
    return {
      'category_name': name
    };
  }

  // For deleting a category (only ID)
  Map<String, dynamic> toDeleteJson() {
    return {
      'category_id': id
    };
  }
}
