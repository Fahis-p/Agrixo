class CategoryModel {
  final int? id;
  final String name;
  final String type;
  final String? iconPath;
  final int createdAt;

  CategoryModel({
    this.id,
    required this.name,
    required this.type,
    this.iconPath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'iconPath': iconPath,
      'createdAt': createdAt,
    };
  }

  // 👇 ADD THIS PART
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      iconPath: map['iconPath'],
      createdAt: map['createdAt'],
    );
  }
}
