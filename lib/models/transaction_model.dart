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
}
