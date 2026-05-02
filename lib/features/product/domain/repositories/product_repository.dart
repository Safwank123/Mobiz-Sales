import 'package:mobiz_sales_app/features/product/domain/entities/product.dart';

import '../entities/product_detail_unit.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts(String storeId);
  Future<List<ProductDetailUnit>> getProductDetail(String productId);
}
