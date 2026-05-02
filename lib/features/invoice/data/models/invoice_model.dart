import '../../domain/entities/invoice.dart';

class InvoiceModel extends Invoice {
  const InvoiceModel({
    required super.id,
    required super.customerName,
    required super.totalAmount,
    required super.date,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      customerName: json['customer_name'] ?? json['customerName'] ?? 'Unknown',
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0.0') ?? 0.0,
      date: json['date'] ?? json['created_at'] ?? '',
    );
  }
}
