class TransactionModel {
  final int? id;
  final String type; // expense / income
  final String category;
  final String subType;
  final double amount;
  final String description;
  final String crop;
  final String date;
  final int createdAt;

  TransactionModel({
    this.id,
    required this.type,
    required this.category,
    required this.subType,
    required this.amount,
    required this.description,
    required this.crop,
    required this.date,
    required this.createdAt,
  });

  // =========================
  // TO MAP (MODEL → DB)
  // =========================
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'subType': subType,
      'amount': amount,
      'description': description,
      'crop': crop,
      'date': date,
      'createdAt': createdAt,
    };
  }

  // =========================
  // FROM MAP (DB → MODEL)
  // =========================
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      category: map['category'],
      subType: map['subType'],
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] ?? '',
      crop: map['crop'] ?? '',
      date: map['date'],
      createdAt: map['createdAt'],
    );
  }
}
