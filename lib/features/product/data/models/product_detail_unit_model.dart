import '../../domain/entities/product_detail_unit.dart';

class ProductDetailUnitModel extends ProductDetailUnit {
  const ProductDetailUnitModel({
    required super.id,
    required super.productId,
    required super.unitId,
    required super.qty,
    required super.price,
    required super.unitName,
  });

  factory ProductDetailUnitModel.fromJson(Map<String, dynamic> json) {
    String unitName = '';
    if (json['units'] is List && json['units'].isNotEmpty) {
      unitName = json['units'][0]['name'] ?? '';
    }

    return ProductDetailUnitModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      unitId: json['unit'] ?? 0,
      qty: double.tryParse(json['qty']?.toString() ?? '0') ?? 0.0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      unitName: unitName,
    );
  }
}
