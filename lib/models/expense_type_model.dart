class ExpenseTypeModel {
  final int? id;
  final String name;
  final String type;
  final int categoryId;
  final String emoji;
  final int createdAt;

  ExpenseTypeModel({
    this.id,
    required this.name,
    required this.emoji,
    this.type = 'expense',
    this.categoryId = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'emoji': emoji,
        'type': type,
        'categoryId': categoryId,
        'createdAt': createdAt,
      };

  factory ExpenseTypeModel.fromMap(Map<String, dynamic> map) {
    return ExpenseTypeModel(
      id: map['id'],
      name: map['name'],
      emoji: map['emoji'] ?? '🧾',
      type: map['type'],
      categoryId: map['categoryId'],
      createdAt: map['createdAt'],
    );
  }
}
