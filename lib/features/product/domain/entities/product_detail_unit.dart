import 'package:equatable/equatable.dart';

class ProductDetailUnit extends Equatable {
  final int id;
  final int productId;
  final int unitId;
  final double qty;
  final double price;
  final String unitName;

  const ProductDetailUnit({
    required this.id,
    required this.productId,
    required this.unitId,
    required this.qty,
    required this.price,
    required this.unitName,
  });

  @override
  List<Object> get props => [id, productId, unitId, qty, price, unitName];
}
