import 'package:equatable/equatable.dart';

class Invoice extends Equatable {
  final String id;
  final String customerName;
  final double totalAmount;
  final String date;

  const Invoice({
    required this.id,
    required this.customerName,
    required this.totalAmount,
    required this.date,
  });

  @override
  List<Object> get props => [id, customerName, totalAmount, date];
}
